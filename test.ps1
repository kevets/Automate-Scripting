#Get-WinEvent -ComputerName localhost -FilterHashTable @{ LogName = "Microsoft-Windows-PrintService/Operational"; ID = 307}

$enablePrintLogging = Get-LogProperties 'Microsoft-Windows-PrintService/Operational'
if (!($enablePrintLogging.Enabled -eq $true)){
    $enablePrintLogging.Enabled = $true
    Set-LogProperties -LogDetails $enablePrintLogging
}
$eventFilter=@{
    StartTime=$([datetime](Get-Date).AddHours(-24))
    LogName=('Microsoft-Windows-PrintService/Admin','Microsoft-Windows-SmbClient/Security')
    ID=(808,316,31017)
}
$newEvent = Get-WinEvent -FilterHashTable $eventFilter -ErrorAction 'SilentlyContinue'
if($newEvent){
    Write-Output "WARNING-EventFound"
    Write-Output $newEvent
}else{
    Write-Output 'OK-NoEventFound NewEvt Empty'}
