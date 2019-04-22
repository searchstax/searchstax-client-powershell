# PowerShell script for downloading a configset from a Zookeeper ensemble.

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$ACCOUNT = "SilverQAAccount"
$uid = "ss644170"
$NAME="test_config"
$APIKEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1NTU2ODk4MzAsImp0aSI6IjEzNGUyNWQ2NGMzNDcxZTcyNjFlOWJmNDEyZjYyZjk5NTA1MjZhNDEiLCJzY29wZSI6WyJkZXBsb3ltZW50LmRlZGljYXRlZGRlcGxveW1lbnQiXSwidGVuYW50X2FwaV9hY2Nlc3Nfa2V5IjoiS2c1K3BJR1pReW1vKzlCTUM2RjYyQSJ9.UJp9PjneR8CozXS8ihoEYF97opeAp8hOIN7ez536y_w"

Write-Host "Downloading configset $NAME from $uid"
# GET /api/rest/v2/account/<account_name>/deployment/<uid>/zookeeper-config/<name>/download/

# Set up HTTP header for authorization APIkey
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "APIkey $APIKEY")

Invoke-RestMethod -outfile "$NAME.zip" -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/zookeeper-config/$NAME/download/" -Method Get -Headers $headers

Write-Host "Look for $NAME.zip in current directory."
Write-Host

Write Host "Exit..."
Exit



