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
   
# account > deployment > zookeeper-config > create
# PowerShell script for adding a Zookeeper configset to a deployment.

# NOTE: Use a version of PowerShell that supports multipart-form data, such as PowerShell Core 6.1+ 
# or Powershell 7.0+. 

# To determine what version of PowerShell you are running, evaluate $PSVersionTable.PSVersion. 
# Version 6.2 may be downloaded from https://github.com/PowerShell/PowerShell/releases

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$ACCOUNT = "AccountName"
$uid = "ss123456"
$NAME="test_config"
$APIKEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1NTU2ODk4MzAsImp0aSI6IjEzNGUyNWQ2NGMzNDcxZTcyNjFlOWJmNDEyZjYyZjk5NTA1MjZhNDEiLCJzY29wZSI6WyJkZXBsb3ltZW50LmRlZGljYXRlZGRlcGxveW1lbnQiXSwidGVuYW50X2FwaV9hY2Nlc3Nfa2V5IjoiS2c1K3BJR1pReW1vKzlCTUM2RjYyQSJ9.UJp9PjneR8CozXS8ihoEYF97opeAp8hOIN7ez536y_w"

echo "Uploading a new Zookeeper config to $uid"
#POST /api/rest/v2/account/{account_name}/deployment/{uid}/zookeeper-config/

# Set up HTTP header for authorization APIkey
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "APIkey $APIKEY")

# Set up form data for payload.

$form = @{
    name = 'test_config'
    files = Get-Item -Path 'conf.zip'
}

# Assuming the zipped config file is in the same directory as this script. 

$RESULTS = Invoke-RestMethod -Method Post -Form $form -Headers $headers `
          -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/zookeeper-config/" 
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS
Write-Host

Write-Host "Exit..."
Exit



