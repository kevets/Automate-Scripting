$TestResult = $true
# Configure Sonicwall Global VPN Profile
# Identifies if default profile is not set(could improve to compare to uploaded file and auto fix)
# Test (default) mode checks the DefaultFile path
# Set mode the DefaultFile path to the desired profile

$DefaultFile = 'C:\Program Files\SonicWall\Global VPN Client\Default.rcf'
$UserData = 'C:\Users\*\AppData\Roaming\SonicWALL\Global VPN Client'

if (!(get-childitem $DefaultFile -ErrorAction silentlycontinue))
{
    Write-Warning 'Default connection profile not set!'
    $TestResult = $false
}
else
{
    Write-Warning 'Default connection profile set! Comparing files...'    
    if (!(compare-object (get-filehash $ConnectionFile).hash (get-filehash $DefaultFile).hash))
    { Write-Warning 'Default connection profile match!'  }
    else {   Write-Warning 'ERR: Default connection profile not matching...';  $TestResult = $false  }
}
# You may add multiple tests
# ForceUpdate user level connection profiles, for existing installs/repair
if ($force)  { 
    write-Warning 'Removing connection profiles and clearing appdata'
    remove-item $UserData -recurse -force
    stop-process -name SWGVC -erroraction silentlycontinue -force
}


switch ($method) {
    "test" {
        # Used in Audit and Enforce Mode
        # You can output anything you want before this, but the last thing returned must be castable into a boolean (true or false)
        return $TestResult
    }
    "set" {
        # Perform action that will make the test return true the next time it runs
        $s1 = copy-item $ConnectionFile $DefaultFile -force
        write-Warning 'Removing connection profiles and clearing appdata'
        remove-item $UserData -recurse -force
        stop-process -name SWGVC -erroraction silentlycontinue -force
        return $s1
    }
    "get" {
        # You can return anything from here, used when in "Monitor" mode
if (!(get-childitem $DefaultFile -ErrorAction silentlycontinue))
{
    Write-Warning 'Default connection profile not set!'
}
else
{
    Write-Warning 'Default connection profile set! Comparing files...'    
    if (!(compare-object (get-filehash $ConnectionFile).hash (get-filehash $DefaultFile).hash))
    { Write-Warning 'Default connection profile match!'  }
    else {   Write-Warning 'ERR: Default connection profile not matching...';  $TestResult = $false  }
}
        return 1
    }
}
