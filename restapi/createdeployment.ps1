# PowerShell script for creating a new deployment. 

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"

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

Write-Host "Creating SolrFromAPI deployment."
Write-Host

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

# For convenience when testing different providers
# Amazon aws   us-west-1
# Google gcp   us-west1
# Azure  azure westus

$body = @{
    name='SolrFromAPI'
    application='Solr'
    application_version='7.5.0'
    termination_lock='false'
    plan_type='DedicatedDeployment'
    plan='DN1'
    region_id='us-west-1'
    cloud_provider_id='aws'
    num_additional_app_nodes='0'
}

$body = $body | ConvertTo-Json

# View the deployment input values
Write-Host $body

$RESULT = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULT = $RESULT | ConvertTo-Json

Write-Host "Creating deployment ..."
Write-Host $RESULT 
Write-Host

Write-Host "Exit..."
Exit



