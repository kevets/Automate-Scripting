# Install-MspPatch.ps1
#
# IMMYBOT PARAMETERS
# $ExpectedHash is Hash of ExpectedHashPath
# $ExpectedHashPath is Path to test post install for validation
# $PatchFile is Installed with msiexec /p
# $DependentSoftware is Software name to use for install validation. Should match filter script

$TestResult = $true

$src = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*\","HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*\" | Get-Item | Get-ItemProperty |Where-Object -FilterScript {$_.DisplayName -ne $null}|Select-Object @{N='Name'; E={$_.DisplayName}}, @{N='Version'; E={$_.DisplayVersion}} | Where-Object -FilterScript {$_.Name -like "$DependentSoftware*"}

if ((($src).Name).count -eq 0)
{ 
    Write-Warning "Dependent Software $DependentSoftware not found!"
    $TestResult = $false
}

if (!(get-childitem $ExpectedHashPath -ErrorAction silentlycontinue))
{
    Write-Warning "Expected Path $ExpectedHashPath not found!"
    $TestResult = $false
}
else
{
    if ((compare-object (get-filehash $ExpectedHashPath).hash $ExpectedHash))
    {
        Write-Warning "Path found! Hash does not match... expecting $ExpectedHash"
        $TestResult = $false
    }
}

switch ($method) {
    "test" {
        return $TestResult
    }
    "get" {
        Write-Host "Expecting: $ExpectedHash"
        if ((($src).Name).count -gt 0) {
            Write-Host "Hash check: "(get-filehash $ExpectedHashPath).hash
            Write-Host "Software found: $src"
        }

        return
    }
    "set" 
    {
        if ((($src).Name).count -eq 0)
        { 
            Write-Warning "Exiting..."
            return $false
        }
        $InstallerLogFile = New-TemporaryFile
        $Arguments = @"
/c msiexec /p "$PatchFile" /qn
"@
        $Process = Start-Process -Wait cmd -ArgumentList $Arguments -Passthru
        Write-Host "$file install executed. Exit Code: $($Process.ExitCode)";
        switch ($Process.ExitCode)
        {
            0 { Write-Host "Success" }
            3010 { Write-Host "Success. Reboot required to complete installation" }
            1641 { Write-Host "Success. Installer has initiated a reboot" }
            default {
                Write-Host "Exit code does not indicate success"
                Get-Content $InstallerLogFile -ErrorAction SilentlyContinue | select-object -Last 50
            }
        }
        if ((compare-object (get-filehash $ExpectedHashPath).hash $ExpectedHash))
        { Write-Warning "Post install hash check does not match..."
            (get-filehash $ExpectedHashPath).hash
            $ExpectedHash
            return $false
        }
        return $Process.ExitCode
    }
}
