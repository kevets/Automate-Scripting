# mater.ps1 - encodes simple scripts for simple obscufation
# enter desired code in curly brackets and run .\mater.ps1
# to generate your .bat launcher. Password is not stored in a secure format.
#######################################################
$code =
{
# SET DESIRED PASSWORD AND TARGET USER FOR SCRIPT EXECUTION HERE
$password = 'changeme'
$tgt = 'changeme'
$securePwd = ConvertTo-SecureString $password -AsPlainText -Force
$cred = new-object System.Management.Automation.PSCredential $tgt,$securePwd
#EXAMPLE OPENS SYSTEM HOSTS FILE
[string]$output=Start-Process PowerShell -Cred $cred -ArgumentList '-noprofile -command &(Start-Process "c:\windows\system32\notepad.exe c:\windows\system32\drivers\etc\hosts" -verb runas)'
return $output
}

$code = [convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($code))
set-content -path mater.bat -value ("powershell.exe -NoProfile -ExecutionPolicy Bypass -EncodedCommand " + $code)
set-content -path mater.src [convert]::FromBase64String([Text.Encoding]::Unicode.GetBytes($code))