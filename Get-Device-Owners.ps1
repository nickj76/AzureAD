## Get Device Owner from AzureAD and output to csv
## work in progress

Connect-AzureAD ## You will be prompted to enter your service account details
$PathCsv = "C:\temp\DeviceList.csv"
# $AADdevices = Get-AzureADDevice -all $true
$AADdevices = Get-AzureADDevice -All $True -Searchstring "uws6"| Select-Object @(
    'DisplayName'
    'UserPrincipalName'
    'ObjectId'
    'AccountEnabled'
    'DeviceOSType'
    'DeviceOSVersion'
    'ApproximateLastLogonTimeStamp'
    'DeviceId'
   )
$devices = @()

$Devices = @()
foreach ($Device in $AADdevices) {
    $DeviceOwner = $Device|Get-AzureADDeviceRegisteredOwner
    $deviceprops = [ordered] @{
        DisplayName = $Device.DisplayName
        User = $DeviceOwner.UserPrincipalName
        ObjectId = $DeviceOwner.ObjectId
        AccountStatus = $DeviceOwner.AccountEnabled
        OS = $Device.DeviceOSType
        OSVersion = $Device.DeviceOSVersion
        Owner = $deviceOwner.DisplayName
        LastLogonTimestamp = $Device.ApproximateLastLogonTimeStamp  
    }
    $deviceobj = new-object -Type PSObject -Property $deviceprops
    $devices += $deviceobj
}
$devices | Export-CSV $PathCsv -NoTypeInformation -Encoding UTF8