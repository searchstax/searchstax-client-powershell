# Custom script for creating ten specific alerts in an deployment. 

# Removes TLS obstacles from connection. Otherwise connections fail. 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$USER = "your login"
#$PASSWORD = $( Read-Host "Input password, please" -AsSecureString) 
#$PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($PASSWORD))
$ACCOUNT = "Your Account"
$uid = "Your deployment uid"
$PASSWORD = "Your Password"

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

# *****************************************************************
# Delete all alerts from target deployment.

Write-Host "Deleting all heartbeat alerts from $uid"
# DELETE /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/heartbeat/all/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/heartbeat/all/" -Method Delete -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

Write-Host "Deleting all threshold alerts from $uid..."
# DELETE /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/all/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/all/" -Method Delete -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# This prompt pauses the script so you can check to see of all alerts were deleted. 
$pause = Read-Host -Prompt 'Check alert lists... Then press ENTER.'

# *****************************************************************
# First new alert: CPU Usage

$body = @{
    name='CPU Usage'
    metric='system_cpu_usage'
    threshold='80'
    unit='percentage'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Second new alert: JVM Heap Memory Used (percentage)
# SearchStax does not offer a percentage threshold alert for JVM Heap Memory Used. 
# Set desired threshold percentage...
$PERCENT = 80
# Inspect the Pulse > CPU Memory JVM > JVM Heap Memory Usage graph to find the max JVM memory limit.
$JVM = 2.00  # GB
$THRESHOLD = $JVM * $PERCENT / 100
Write-Host "JVM Usage threshold is $THRESHOLD GB"

$body = @{
    name='JVM Heap Memory Used'
    metric='system_jvm_memory_used'
    unit='GB'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body.threshold = $THRESHOLD

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Third new alert: Disk Space Used (percentage)
# SearchStax does not offer a percentage threshold alert for Disk Space Used. 
# Set desired threshold percentage...
$PERCENT = 80
# Inspect the deployment's details screen for the max disk space
$DISKSPACE = 32  # GB
$THRESHOLD = $DISKSPACE * $PERCENT / 100
Write-Host "Disk Usage threshold is $THRESHOLD GB"

$body = @{
    name='Disk Space Used'
    metric='system_disk_space_used'
    unit='GB'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body.threshold = $THRESHOLD  # How to put the value of a variable into an array. 

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Fourth new alert: Search Average Time/Request (ms)

$body = @{
    name='Search Average Time/Request'
    metric='search_avg_responsetime_per_request'
    threshold='3000'
    unit='number'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Fifth new alert: Search Timeouts

$body = @{
    name='Search Timeouts'
    metric='search_timeouts'
    threshold='10'
    unit='number'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Sixth new alert: Search Errors

$body = @{
    name='Search Error Count'
    metric='search_error_count'
    threshold='10'
    unit='number'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Seventh new alert: Index Average Time/Request (ms)

$body = @{
    name='Index Average Time/Request'
    metric='index_avg_responsetime_per_request'
    threshold='60000'
    unit='number'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Eighth new alert: Indexing Timeouts

$body = @{
    name='Index Timeouts'
    metric='index_timeouts'
    threshold='10'
    unit='number'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Ninth new alert: Index Errors

$body = @{
    name='Index Errors'
    metric='index_error_count'
    threshold='10'
    unit='number'
    operator='>'
    host='*'
    delay_mins='1'
    max_alerts='2'
    repeat_every='5'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

# *****************************************************************
# Tenth new alert: Heartbeat Alert

$body = @{
    name='Heartbeat Alert'
    host='*'
    failures='5'
    interval='2'
    max_alerts='1'
    email=@('bruce+null@searchstax.com')
}

$body = $body | ConvertTo-Json

Write-Host "Adding new heartbeat alert to $uid..."
Write-Host $body

# POST /api/rest/v2/account/{account_name}/deployment/{uid}/alerts/heartbeat/

$RESULTS = Invoke-RestMethod -uri "https://app.searchstax.com/api/rest/v2/account/$ACCOUNT/deployment/$uid/alerts/heartbeat/" -Method Post -Body $body -ContentType 'application/json' -Headers $headers
$RESULTS = $RESULTS | ConvertTo-Json

Write-Host $RESULTS

Write-Host "Exit..."
Exit