# Set-HideFromAddressList.ps1
#
# Sets msExchHideFromAddressLists="TRUE" in a matching OU. Defaults to OUs containing 'disabled'
#
# IMMYBOT PARAMETERS
# $ExpectedHash is Hash of ExpectedHashPath
# $ExpectedHashPath is Path to test post install for validation
# $PatchFile is Installed with msiexec /p
# $DependentSoftware is Software name to use for install validation. Should match filter script

Import-Module ActiveDirectory 
Set-Location AD:
Set-Location "DC=domain,DC=local"

$aduser = "upn"

Set-adUser $aduser -REPLACE @{msExchHideFromAddressLists="TRUE"}
set-adUser $aduser -Clear showInAddressbook 
Set-ADUser $aduser -Replace @{MailNickName = "$aduser"}



##########################This will prompt you for a single AD username, and update that object's attributes to hide it from the GAL
Import-Module ActiveDirectory 
Set-Location AD:
#If you dont know where the AD location is, run DIR after you run ">Set-Location AD:" to see a list of possible locations.
Set-Location "DC=SafirRosetti,DC=local"

#$SOMEUSER = Read-Host -Prompt 'What is your username?'
#This will set the AD user object's attributes to the email from the GAL 
#Set-adUser $SOMEUSER -REPLACE @{msExchHideFromAddressLists="TRUE"} -Verbose
#Set-adUser $SOMEUSER -Clear showInAddressbook -Verbose
#Set-ADUser $SOMEUSER -Replace @{MailNickName = "$SOMEUSER"} -Verbose

##########################Set all user objects' attributes within an OU to be hidden from the GAL

#Prompts you for OU. Expected input is 'OU=TopLevelOU' or 'OU=ParentOU,OU=ChildOU' (dont include quotes)
$SOMEOU= Read-Host -Prompt "What OU should we check? `nFor sub-directory OU:`nOU=ParentOU,OU=ChildOU`nFor top-level OU:`nOU=SingleOU`n"
Get-ADUser -SearchBase "$SOMEOU,DC=SafirRosetti,DC=local" -Filter * | Set-adUser -REPLACE @{msExchHideFromAddressLists="TRUE"} -Verbose
Get-ADUser -SearchBase "$SOMEOU,DC=SafirRosetti,DC=local" -Filter *| #Set-adUser -Clear showInAddressbook -Verbose
##Setting MailNickName is tricky. You have to store the Username into a variable/array/or CSV and pipe it into the Set-ADUser command. This is what I was able to find online, not too sure about this one...
Get-ADUser -Filter * -SearchScope Subtree -SearchBase "$SOMEOU,DC=SafirRosetti,DC=local" |  ForEach-Object {Set-ADUser -Identity $_ -Replace @{mailNickname=$_.samaccountname}}

##Get a list of all users in ANY OU that contains the word "disabled" (table)
Get-ADOrganizationalUnit -Filter 'Name -like "*Disabled*"' |ForEach-Object {Get-ADUser -Filter * -SearchScope Subtree -SearchBase $_.distinguishedname} | Format-Table Name, DistinguishedName -A 
##Get a list of all users in all FIRST-LEVEL OUs that contains the word "disabled" (table)
Get-ADOrganizationalUnit -SearchScope OneLevel -Filter 'Name -like "*Disabled*"' |ForEach-Object {Get-ADUser -Filter * -SearchScope Subtree -SearchBase $_.distinguishedname} | Format-Table Name, DistinguishedName -A 

##Export Name, msExchHideFromAddressLists, mailNickname, DistinguishedName of users in "*Disabled*" OU where msExchHideFromAddressLists -eq TRUE
Get-ADOrganizationalUnit -Filter 'Name -like "*Disabled*"' | ForEach-Object {Get-ADUser -SearchScope Subtree -SearchBase $_.distinguishedname -Filter * -Properties * | Where msExchHideFromAddressLists -eq $true } | Select Name,msExchHideFromAddressLists,mailNickname,DistinguishedName |  Export-Csv -Path C:\Users\witadmin\Documents\FilesWmiData.csv -NoTypeInformation
##Export Name, msExchHideFromAddressLists, mailNickname, DistinguishedName of users in "*Disabled*" OU where msExchHideFromAddressLists -eq FALSE
Get-ADOrganizationalUnit -Filter 'Name -like "*Disabled*"' | ForEach-Object {Get-ADUser -SearchScope Subtree -SearchBase $_.distinguishedname -Filter * -Properties * | Where msExchHideFromAddressLists -eq $false } | Select Name,msExchHideFromAddressLists,mailNickname,DistinguishedName |  Export-Csv -Path C:\Users\witadmin\Documents\FilesWmiData.csv -NoTypeInformation
