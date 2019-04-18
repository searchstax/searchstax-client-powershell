# PowerShell script for downloading a configset from a Zookeeper ensemble.

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

echo "Downloading Zookeeper configset $NAME from $uid"
#GET /api/rest/v2/account/{account_name}/deployment/{uid}/zookeeper-config/{name}/download/

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

Invoke-RestMethod -outfile "$NAME.zip" -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/zookeeper-config/$NAME/download/" -Method Get -Headers $headers

Write-Host "Look for $NAME.zip in current directory."
Write-Host

Write Host "Exit..."
Exit



