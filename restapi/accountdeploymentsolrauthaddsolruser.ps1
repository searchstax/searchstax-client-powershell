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
   
# account > deployment > solr > auth > add_solr_user
# PowerShell script for adding a Solr Basic Auth user to a deployment.

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"
$uid = "ss213022"
$APIKEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1NTEwNDUyODAsImp0aSI6ImNlNWJhZGM0OWVmODg3ODllZDVlNWZjZjM1ODg3OWQyYTQ0ZmU4MWQiLCJzY29wZSI6WyJkZXBsb3ltZW50LmRlZGljYXRlZGRlcGxveW1lbnQiXSwidGVuYW50X2FwaV9hY2Nlc3Nfa2V5IjoiS2c1K3BJR1pReW1vKzlCTUM2RjYyQSJ9.ziCYzMAvTEsKNOxIfoEG54RDJQu19NQSN1P5_f6alls"

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

# Set up HTTP header for authorization 
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")
#$headers.Add("Authorization", "Apikey $APIKEY")

$body = @{
    username='demoSolrUser'
    password='test123'
    role='Admin'
}

$body = $body | ConvertTo-Json

Write-Host "Adding new user to $uid..."
Write-Host $body

#POST https://app.searchstax.com/api/rest/v2/account/<account_name>/deployment/<uid>/solr/auth/add-user/
$RESULT = Invoke-RestMethod -Method Post -body $body -ContentType 'application/json' -Headers $headers `
         -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/solr/auth/add-user/" 
$RESULT = $RESULT | ConvertTo-Json

Write-Host $RESULT
Write-Host

Write-Host "Exit..."
Exit



