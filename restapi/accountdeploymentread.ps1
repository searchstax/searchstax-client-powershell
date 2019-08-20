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
   
# account > deployment > read
# PowerShell script for listing the details of a deployment.

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"
$uid = "ss213022"

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

$TOKEN = $TOKEN.token
Write-Host "Obtained TOKEN" $TOKEN
Write-Host

Write-Host "Getting deployment details of $uid..."
#GET https://app.searchstax.com/api/rest/v2/account/{account_name}/deployment/{uid}/

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

$DETAILS = Invoke-RestMethod -Method Get -ContentType 'application/json' -Headers $headers `
          -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/" 
$DETAILS1 = $DETAILS | ConvertTo-Json

Write-Host $DETAILS1
Write-Host

$GB = [math]::pow( 1024, 3 )  # To convert raw memory to rounded GB like the UI uses.

$DISK = $DETAILS.specifications.disk_space / $GB
$JVM = $DETAILS.specifications.jvm_heap_memory / $GB
$MEMORY = $DETAILS.specifications.physical_memory / $GB

Write-Host "Disk space is $DISK GB"
Write-Host "JVM heap memory is $JVM GB"
Write-Host "Physical memory is $MEMORY GB"
Write-Host

Write Host "Exit..."
Exit



