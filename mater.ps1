# mater.ps1 - encodes simple scripts for simple obscufation
# enter desired code in curly brackets and run .\mater.ps1
# to generate your .bat launcher. Password is not stored in a secure format.
#######################################################
$code_src =
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

$code_enc = [convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($code_src))
set-content -path mater.bat -value ("powershell.exe -NoProfile -ExecutionPolicy Bypass -EncodedCommand " + $code_enc)
$code_dec = [Text.Encoding]::UTF8.GetString([convert]::FromBase64String($code_enc))
set-content -path mater.src -value ($code_dec)