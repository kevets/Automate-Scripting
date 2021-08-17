#Install-ZipFonts.ps1
#
# DEV - ensure test phase fails until detection is working...
$TestResult = $false


$fontSourceFolder = Split-Path $ZippedFonts -Parent
$SystemFontsPath = "C:\Windows\Fonts\"
$ExpectedFonts = Get-ChildItem $fontSourceFolder -Include '*.ttf','*.ttc','*.otf' -recurse
$FontsToInstall = $ExpectedFonts | Where-Object{ !(Test-Path $_) }
$FontsToInstallCount = $FontsToInstall | Measure-Object | Select-Object -expand Count
$FontsToInstall
if($FontsToInstallCount -gt 0)
{
	Write-Warning "$FontsToInstallCount fonts will be installed`r`n`r`n$(($FontsToInstall | Out-String))"
	Test-Result = $false
}

switch($method)
{
	"test"{
		return $TestResult
	}
	"set" {
		foreach($FontFile in $ExpectedFonts)
		{
			$targetPath = Join-Path $SystemFontsPath $FontFile.Name
			if(Test-Path -Path $targetPath)
			{
				$FontFile.Name + " already installed"
			}
			else 
			{
				Write-Host "Installing font " + $FontFile.Name				
				#Extract Font information for Reqistry 
				$ShellFolder = (New-Object -COMObject Shell.Application).Namespace($fontSourceFolder)
				$ShellFile = $ShellFolder.ParseName($FontFile.name)
				$ShellFileType = $ShellFolder.GetDetailsOf($ShellFile, 2)
				#Set the $FontType Variable
				If ($ShellFileType -Like '*TrueType font file*') {$FontType = '(TrueType)'}
					
				#Update Registry and copy font to font directory
				$RegName = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
				New-ItemProperty -Name $RegName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.name -Force | out-null
				Copy-item $FontFile.FullName -Destination $SystemFontsPath
				Write-Host "Done"
			}
		}
	}
}
