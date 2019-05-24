# account > deployment > alerts > create
# Script for creating an alert in an deployment. 

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"
$uid = "ss416352"

Write-Host "Asking for an authorization token for $USER..."
Write-Host

$body = @{
    username=$USER
    password=$PASSWORD
}
Remove-Variable PASSWORD

$body = $body | ConvertTo-Json

$TOKEN = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/obtain-auth-token/" -Method Post -Body $body -ContentType 'application/json' 
$TOKEN = $TOKEN.token
Remove-Variable body

Write-Host "Obtained TOKEN" $TOKEN
Write-Host

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

Write-Host "Adding an alert to $uid"
Write-Host
#
$body = @{
    name='High Disk Usage'
    metric='system_disk_space_used'
    threshold='50'
    unit='GB'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -Method Post -Body $body -ContentType 'application/json' -Headers $headers `
          -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" 
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

Write-Host "Exit..."
Exit