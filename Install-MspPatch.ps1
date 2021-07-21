# Install MSP patch
# IMMYBOT PARAMERTERS
# $ExpectedHash is Hash of ExpectedHashPath
# $ExpectedHashPath is Path to test post install for validation
# $PatchFile is Installed with msiexec /p

$TestResult = $true

if (!(compare-object (get-filehash $ExpectedHashPath).hash $ExpectedHash))

{
    Write-Warning "Expected Hash not found"
    $TestResult = $false
}

switch ($method) {
    "test" {
        return $TestResult
    }
    "get" {
        (get-filehash $ExpectedHashPath).hash
        $ExpectedHash
        return
    }
    "set" {
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
        return $Process.ExitCode
    }
}
