# Install-RingCentralApps.ps1
#
#RingCentral install assistant

$TestResult = $true

$src = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*\","HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*\" | Get-Item | Get-ItemProperty |Where-Object -FilterScript {$_.DisplayName -ne $null}|Select-Object @{N='Name'; E={$_.DisplayName}}, @{N='Version'; E={$_.DisplayVersion}} | Where-Object -FilterScript {$_.Name -like "RingCentral*"}

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
      write-Output "Starting RingCentral App 64bit install"
      $dir = 'c:\windows\temp'
      mkdir $dir -ea SilentlyContinue > out-null
      $webClient = New-Object System.Net.WebClient
      $url = 'https://app.ringcentral.com/download/RingCentral-x64.msi'
      $file = "$($dir)\RingCentral-x64.msi"
      $webClient.DownloadFile($url,$file)
      $install = Start-Process msiexec.exe -ArgumentList "/i $file ALLUSERS=1 /qn /norestart /log $dir\RCapp.log" -Wait -PassThru
      $hex = "{0:x}" -f $install.ExitCode
      $exit_code = "0x$hex"
      
      # Convert hex code to human readable
      $message = Switch ($exit_code) {
         "0x0" { "SUCCESS: Install started."; break }
         default { "WARNING: Unknown exit code."; break }
      }
      write-Output "$message (Code: $exit_code)"
      
      write-Output "Starting RingCentral Meetings App install"
      $dir = 'c:\windows\temp'
      mkdir $dir -ea SilentlyContinue > out-null
      $webClient = New-Object System.Net.WebClient
      $url = 'https://downloads.ringcentral.com/RCM/RC/meetings/win/RCMeetingsClientSetup.msi'
      $file = "$($dir)\RCMeetingsClientSetup.msi"
      $webClient.DownloadFile($url,$file)
      $install = Start-Process msiexec.exe -ArgumentList "/i $file ALLUSERS=1 /qn /norestart /log $dir\RCMapp.log" -Wait -PassThru
      $hex = "{0:x}" -f $install.ExitCode
      $exit_code = "0x$hex"
      
      # Convert hex code to human readable
      $message = Switch ($exit_code) {
         "0x0" { "SUCCESS: Install started."; break }
         default { "WARNING: Unknown exit code."; break }
      }
      write-Output "$message (Code: $exit_code)"
      
      # Convert hex code to human readable
      $message = Switch ($exit_code) {
         "0x0" { "SUCCESS: Install started."; break }
         default { "WARNING: Unknown exit code."; break }
      }
      write-Output "$message (Code: $exit_code)"        $Process = Start-Process -Wait cmd -ArgumentList $Arguments -Passthru
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
        return $exit_code
    }
}



