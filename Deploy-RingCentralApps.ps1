#RingCentral install assistant
write-Output "Starting RingCentral App 64bit install"
$dir = 'c:\windows\temp'
mkdir $dir -ea SilentlyContinue > out-null
$webClient = New-Object System.Net.WebClient
$url = 'https://app.ringcentral.com/download/RingCentral-x64.msi'
#Old URL $url = 'http://downloads.ringcentral.com/glip/rc/20.2.1/x64/RingCentral-20.2.1-x64.msi'
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
#Old URL $url = 'http://dn.ringcentral.com/data/web/download/RCMeetings/1210/RCMeetingsClientSetup.msi'
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

write-Output "Starting RingCentral Meetings Outlook Plugin install"
$dir = 'c:\windows\temp'
mkdir $dir -ea SilentlyContinue > out-null
$webClient = New-Object System.Net.WebClient
$url = 'http://dn.ringcentral.com/data/web/download/RCMeetings/1210/RCMeetingsOutlookPluginSetup.msi'
$file = "$($dir)\RCMeetingsOutlookPluginSetup.msi"
$webClient.DownloadFile($url,$file)
$install = Start-Process msiexec.exe -ArgumentList "/i $file ALLUSERS=1 /qn /norestart /log $dir\RCMPapp.log" -Wait -PassThru
$hex = "{0:x}" -f $install.ExitCode
$exit_code = "0x$hex"

# Convert hex code to human readable
$message = Switch ($exit_code) {
   "0x0" { "SUCCESS: Install started."; break }
   default { "WARNING: Unknown exit code."; break }
}
write-Output "$message (Code: $exit_code)"