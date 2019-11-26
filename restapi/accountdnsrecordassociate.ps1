#   Copyright 2019 SearchStax, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#   -----------------------------------------------------------------------
   
# account > dns-record > associate
# PowerShell script for updating a DNS CNAME record in a deployment.

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverSupportAccount"
$NAME = "alias1"

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

$body = @{
    deployment='ss907614'
    ttl='300'
}

$body = $body | ConvertTo-Json

# Update the CNAME record. 
Write-Host $body

Write-Host "Updating CNAME of" $NAME
Write-Host
#PATCH https://app.searchstax.com/api/rest/v2/account/<account_name>/dns-record/<name>/
$RESULT = Invoke-RestMethod -Method Patch -body $body -ContentType 'application/json' -Headers $headers `
         -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/dns-record/$NAME/" 
$RESULT = $RESULT | ConvertTo-Json

Write-Host $RESULT
Write-Host

Write Host "Exit..."
Exit



