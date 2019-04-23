# PowerShell script for adding a Zookeeper configset to a deployment.

# NOTE: This script requires PowerShell Core 6.1+. We used Version 6.2.

# To determine what version of PowerShell you are running, evaluate $PSVersionTable.PSVersion. 
# Version 6.2 may be downloaded from https://github.com/PowerShell/PowerShell/releases

# The issue is PowerShell's long-standing difficulty with multipart/form-data. See Example 4 of
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-6

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$ACCOUNT = "SilverQAAccount"
$uid = "ss644170"
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

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/zookeeper-config/" -Method Post -Form $form -Headers $headers

Write-Host $RESULTS
Write-Host

Write-Host "Exit..."
Exit



