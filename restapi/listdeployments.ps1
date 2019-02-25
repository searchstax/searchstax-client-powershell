# PowerShell script for deleting SolrFromAPI.

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
Remove-Variable body

Write-Host "Obtained TOKEN" $TOKEN.token
$TOKEN = $TOKEN.token
Write-Host $TOKEN
Write-Host

echo "Checking number of DEPLOYMENTS in Tenant Account"
#GET https://app.searchstax.com/api/rest/v2/account/<account_name>/deployment/

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

$DEPLOYMENTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/SilverQAAccount/deployment/" -Method Get -ContentType 'application/json' -Headers $headers
$DEPLOYMENTS1 = $DEPLOYMENTS | ConvertTo-Json

Write-Host $DEPLOYMENTS1
Write-Host
Write-Host "Deployment COUNT is" $DEPLOYMENTS.count
Write-Host

Write Host "Exit..."
Exit



