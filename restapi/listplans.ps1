# PowerShell script for listing the plans available to an account.

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

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

Write-Host "Getting health of" $uid
Write-Host
#GET https://app.searchstax.com/api/rest/v2/account/<account_name>/plan/?page=1&application=solr&plan_type=DedicatedPlan

$RESULT = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/SilverQAAccount/plan/?page=1&application=solr&plan_type=DedicatedPlan" -Method Get -Headers $headers
$RESULT = $RESULT | ConvertTo-Json

Write-Host $RESULT
Write-Host

Write Host "Exit..."
Exit



