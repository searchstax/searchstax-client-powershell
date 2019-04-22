# PowerShell script for associating an APIkey with SolrFromAPI.

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"
$APIKEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1NTU2ODk4MzAsImp0aSI6IjEzNGUyNWQ2NGMzNDcxZTcyNjFlOWJmNDEyZjYyZjk5NTA1MjZhNDEiLCJzY29wZSI6WyJkZXBsb3ltZW50LmRlZGljYXRlZGRlcGxveW1lbnQiXSwidGVuYW50X2FwaV9hY2Nlc3Nfa2V5IjoiS2c1K3BJR1pReW1vKzlCTUM2RjYyQSJ9.UJp9PjneR8CozXS8ihoEYF97opeAp8hOIN7ez536y_w"
$uid = "ss644170"

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

Write-Host "SolrFromAPI UID is $uid"
Write-Host

$body = @{
    apikey=$APIKEY
    deployment=$uid
}

$body = $body | ConvertTo-Json

Write-Host "Associating APIkey with deployment..." 
Write-Host $body
Write-Host

#POST https://app.searchstax.com/api/rest/v2/account/<account_name>/apikey/associate/
$RESULT = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/apikey/associate/" -Method Post -body $body -ContentType 'application/json' -Headers $headers
$RESULT = $RESULT | ConvertTo-Json

Write-Host $RESULT
Write-Host

Write-Host "Exit..."
Exit



