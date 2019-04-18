# PowerShell script for deleting a configset in a Zookeeper ensemble.

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"
$uid = "ss644170"
$NAME="test_config"


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

echo "Deleting Zookeeper configset $NAME from $uid"
#DELETE /api/rest/v2/account/{account_name}/deployment/{uid}/zookeeper-config/{name}/

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/zookeeper-config/$NAME/" -Method Delete -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS
Write-Host

Write Host "Exit..."
Exit



