# Remove-RingCentralApps.ps1
#

#RingCentral uninstall assistant
write-Output "Starting RingCentral App 64bit uninstall"
$dir = 'c:\windows\temp'
mkdir $dir -ea SilentlyContinue > out-null
$webClient = New-Object System.Net.WebClient
$url = 'http://downloads.ringcentral.com/glip/rc/20.2.1/x64/RingCentral-20.2.1-x64.msi'
$file = "$($dir)\RingCentral-20.2.1-x64.msi"
$webClient.DownloadFile($url,$file)
$install = Start-Process msiexec.exe -ArgumentList "/x $file /qn" -Wait -PassThru
$hex = "{0:x}" -f $install.ExitCode
$exit_code = "0x$hex"

# Convert hex code to human readable
$message = Switch ($exit_code) {
   "0x0" { "SUCCESS: Uninstall started."; break }
   default { "WARNING: Unknown exit code."; break }
}
write-Output "$message (Code: $exit_code)"

write-Output "Starting RingCentral Meetings App uninstall"
$dir = 'c:\windows\temp'
mkdir $dir -ea SilentlyContinue > out-null
$webClient = New-Object System.Net.WebClient
$url = 'http://dn.ringcentral.com/data/web/download/RCMeetings/1210/RCMeetingsClientSetup.msi'
$file = "$($dir)\RCMeetingsClientSetup.msi"
$webClient.DownloadFile($url,$file)
$install = Start-Process msiexec.exe -ArgumentList "/x $file /qn" -Wait -PassThru
$hex = "{0:x}" -f $install.ExitCode
$exit_code = "0x$hex"

# Convert hex code to human readable
$message = Switch ($exit_code) {
   "0x0" { "SUCCESS: Uninstall started."; break }
   default { "WARNING: Unknown exit code."; break }
}
write-Output "$message (Code: $exit_code)"

write-Output "Starting RingCentral Meetings Outlook Plugin uninstall"
$dir = 'c:\windows\temp'
mkdir $dir -ea SilentlyContinue > out-null
$webClient = New-Object System.Net.WebClient
$url = 'http://dn.ringcentral.com/data/web/download/RCMeetings/1210/RCMeetingsOutlookPluginSetup.msi'
$file = "$($dir)\RCMeetingsOutlookPluginSetup.msi"
$webClient.DownloadFile($url,$file)
$install = Start-Process msiexec.exe -ArgumentList "/x $file /qn" -Wait -PassThru
$hex = "{0:x}" -f $install.ExitCode
$exit_code = "0x$hex"

# Convert hex code to human readable
$message = Switch ($exit_code) {
   "0x0" { "SUCCESS: Uninstall started."; break }
   default { "WARNING: Unknown exit code."; break }
}
write-Output "$message (Code: $exit_code)"