#   Copyright 2023 SearchStax, Inc.
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
   
# users > add-user > create
# Script for inviting a new user to a deployment. 

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "user@company.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "Account Name"

Write-Host "Asking for an authentication token for $USER..."
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

Write-Host

$body = @{
    email='user@company.net'
    role='Admin'
    first_name='First'
    last_name='Last'    
    phone_number='8005551212'
}

$body = $body | ConvertTo-Json

Write-Host "Adding new user to $ACCOUNT..."
Write-Host $body

# POST api/rest/users/add-user?account=<account_name>

$RESULTS = Invoke-RestMethod -Method Post -Body $body -ContentType 'application/json' -Headers $headers `
          -uri "https://app.searchstax.com/api/rest/users/add-user?account=$ACCOUNT" 
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

Write-Host "Exit..."
Exit