# Script for deleting a specific heartbeat alert. 

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"
$ALERTID = "139"

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

Write-Host "Checking number of DEPLOYMENTS in Tenant Account"
#GET https://app.searchstax.com/api/rest/v2/account/<account_name>/deployment/

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

$DEPLOYMENTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/" -Method Get -ContentType 'application/json' -Headers $headers
#$DEPLOYMENTS1 = $DEPLOYMENTS | ConvertTo-Json

#Write-Host $DEPLOYMENTS1
#Write-Host
Write-Host "Deployment COUNT is" $DEPLOYMENTS.count
Write-Host

# Get deployment UID from JSON output of $DEPLOYMENTS.

Write-Host "Obtaining a deployment UID from list of deployments"
Write-Host
$uid = ForEach ($Result in $DEPLOYMENTS.results) { IF( $Result.name -eq 'SolrFromAPI') {$Result.uid } }

Write-Host "SolrFromAPI UID is $uid"
Write-Host

Write-Host "Deleting heartbeat alert $ALERTID from $uid"
# DELETE /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/heartbeat/{id}/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/heartbeat/$ALERTID/" -Method Delete -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

Write-Host "Exit..."
Exit