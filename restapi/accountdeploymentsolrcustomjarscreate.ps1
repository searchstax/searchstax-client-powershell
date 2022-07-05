#   Copyright 2022 SearchStax, Inc.
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
   
# account > deployment > solr > custom-jars > create
# PowerShell script for adding a JAR file to a deployment.

# NOTE: Use a version of PowerShell that supports multipart-form data, such as PowerShell Core 6.1+ 
# or Powershell 7.0+. 

# To determine what version of PowerShell you are running, evaluate $PSVersionTable.PSVersion. 
# Version 6.2 may be downloaded from https://github.com/PowerShell/PowerShell/releases

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "user@company.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "AccountName"
$uid = "ss123456"
$SID = "4"
$JARFILE = "jarfile.jar"

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

# Set up HTTP header for authorization APIkey
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

echo "Uploading a new JAR file to $uid"
#POST /api/rest/v2/account/{account_name}/deployment/{uid}/solr/custom-jars/

# Set up form data for payload.

$form = @{
    file = Get-Item -Path '$JARFILE'
}

# Assuming the JAR file is in the same directory as this script. 

$RESULTS = Invoke-RestMethod -Method Post -Form $form -Headers $headers `
          -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/solr/custom-jars/" 
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS
Write-Host

Write-Host "Exit..."
Exit



