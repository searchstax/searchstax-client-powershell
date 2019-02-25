# PowerShell script for adding tags to SolrFromAPI.

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

$DEPLOYMENTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/" -Method Get -ContentType 'application/json' -Headers $headers

# Get deployment UID from JSON output of $DEPLOYMENTS.

Write-Host "Obtaining a deployment UID from list of deployments"
Write-Host
$uid = ForEach ($Result in $DEPLOYMENTS.results) { IF( $Result.name -eq 'SolrFromAPI') {$Result.uid } }

Write-Host "SolrFromAPI UID is $uid"
Write-Host

$body = @{
    tags='demo','test'
}

$body = $body | ConvertTo-Json

# View the deployment input values
Write-Host $body

Write-Host "Adding tags to" $uid
Write-Host
#POST https://app.searchstax.com/api/rest/v2/account/<account_name>/deployment/<uid>/tags/
$RESULT = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/tags/" -Method Post -body $body -ContentType 'application/json' -Headers $headers
$RESULT = $RESULT | ConvertTo-Json

Write-Host $RESULT
Write-Host

Write Host "Exit..."
Exit



