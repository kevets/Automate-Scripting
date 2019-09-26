# Umbrella Roaming Client NCSI workaround
# Requires Admin privileges
If ((Get-Content "$($env:windir)\system32\Drivers\etc\hosts" ) -notcontains "131.107.255.255   dns.msftncsi.com")   
 {ac -Encoding UTF8  "$($env:windir)\system32\Drivers\etc\hosts" "131.107.255.255   dns.msftncsi.com" }
 else {"Already Present"}