# account > alerts > metrics
# Script for listing the alerts metrics of an account. Writes to C:\metrics.txt.
# You may need to run PowerShell AS THE ADMINISTRATOR to write the text file at the end. 

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"

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

# GET /api/rest/v2/account/<account>/alerts/metrics/

$RESULTS = Invoke-RestMethod -Method Get -Headers $headers `
          -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/alerts/metrics/" 

Write-Host "Available metrics are..."
Foreach ($METRIC in $RESULTS) {Write-Host $METRIC.description}
Write-Host

Write-Host "Writing list of alert metrics to C:\metrics.txt."
$RESULTS = $RESULTS | ConvertTo-Json | Out-File C:\metrics.txt

Write-Host "Exit..."
Exit