# Install-MspPatch.ps1
# Install MSP patch
# IMMYBOT PARAMERTERS
# $ExpectedHash is Hash of ExpectedHashPath
# $ExpectedHashPath is Path to test post install for validation
# $PatchFile is Installed with msiexec /p
# $DependentSoftware is Software name to use for install validation. Should match filter script

$TestResult = $true

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
        Write-Host "Found: "(get-filehash $ExpectedHashPath).hash
        return
    }
    "set" {
        if ((Get-ChildItem "HKLM:Software\Microsoft\Windows\CurrentVersion\Uninstall") | Where-Object { $_."Name" -like "$DependentSoftware*" })
        { 
            Write-Warning "Dependent Software $DependentSoftware not found!"
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
                Get-Content $InstallerLogFile -ErrorAction SilentlyContinue | select -Last 50
            }
        }
        if ((compare-object (get-filehash $ExpectedHashPath).hash $ExpectedHash))
        { Write-Warning "PostCheck Hash does not match post install..."
            (get-filehash $ExpectedHashPath).hash
            $ExpectedHash
            return $TestResult = $false
        }
        return $Process.ExitCode
    }
}
