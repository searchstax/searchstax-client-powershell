# PowerShell script for listing the specifications of a deployment.

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "bruce@searchstax.com"
#$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
#$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "SilverQAAccount"
$uid = "ss571300"
$PASSWORD = "X#a73Aa3#tL%"

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

Write-Host "Getting deployment details of $uid..."
#GET https://app.searchstax.com/api/rest/v2/account/{account_name}/deployment/{uid}/

Write-Host 

# Set up HTTP header for authorization token
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Token $TOKEN")

$DETAILS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/" -Method Get -ContentType 'application/json' -Headers $headers
#$DETAILS1 = $DETAILS | ConvertTo-Json

#Write-Host $DETAILS1
#Write-Host

$GB = [math]::pow( 1024, 3 )  # To convert raw memory to rounded GB like the API uses.

$DISK = $DETAILS.specifications.disk_space / $GB
$JVM = $DETAILS.specifications.jvm_heap_memory / $GB
$MEMORY = $DETAILS.specifications.physical_memory / $GB

Write-Host "Disk space is $DISK GB"
Write-Host "JVM heap memory is $JVM GB"
Write-Host "Physical memory is $MEMORY GB"
Write-Host


Write Host "Exit..."
Exit



