# Import Pode and Pode.Web modules
Import-Module Pode
Import-PodeModule -Name SqlServer
Import-PodeModule -Name ActiveDirectory
#Import-Module Pode.Web
# Function to Update ThirdParty passwords
function Set-ThirdPartyPassword {
    param (
        [string]$Email,
        [string]$Password,
        [string]$ApiKey,
        [string]$contenttype
    )
    $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $headers.Add("api-key", "$ApiKey")
$body = @"
{
    "email"        : "$Email",
    "new_password" : "$Password"
}
"@
    Try {

        $response = Invoke-RestMethod 'https://sso.adminfamily.com/password/reset/' -Method 'POST' -Headers $headers -Body $body -ContentType 'application/json'
        if ($response) { return $response }else { return @{Status = "No Response Returned" } }
    }
    catch {
        if ($response) { return $response }else { return @{Status = "No Response Returned" } }
    }
}
# Function to log events to SQL database
function Send-EventToDB {
    param (
        [hashtable]$DBObject,
        [string]$Username,
        [string]$Status,
        [string]$FactorUsed,
        [string]$FactorValue,
        [string]$IPAddress,
        [string]$ErrorDetails,
        [string]$SNUpdateStatus,
        [string]$SNUpdateMessage,
        [string]$CallerId
    )

    # Create SQL connection
    $connectionString = "Server=$($DBObject["SQLServer"]);Database=$($DBObject["Database"]);Integrated Security=True;TrustServerCertificate=True;"
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    # Create SQL command with parameters
    $sqlQuery = @"
        INSERT INTO PasswordResetLogs (Username, Status, FactorUsed, FactorValue, IPAddress, ErrorDetails, SNUpdateStatus, SNUpdateMessage, CallerId)
        VALUES (@Username, @Status, @FactorUsed, @FactorValue, @IPAddress, @ErrorDetails, @SNUpdateStatus, @SNUpdateMessage, @CallerId);
"@

    $command = $connection.CreateCommand()
    $command.CommandText = $sqlQuery

    # Add parameters to command
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Username", [Data.SqlDbType]::VarChar, 50))).Value = $Username
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Status", [Data.SqlDbType]::VarChar, 50))).Value = $Status
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@FactorUsed", [Data.SqlDbType]::VarChar, 50))).Value = $FactorUsed
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@FactorValue", [Data.SqlDbType]::VarChar, 50))).Value = $FactorValue
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@IPAddress", [Data.SqlDbType]::VarChar, 50))).Value = $IPAddress
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@ErrorDetails", [Data.SqlDbType]::VarChar, 300))).Value = $ErrorDetails
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@SNUpdateStatus", [Data.SqlDbType]::VarChar, 50))).Value = $SNUpdateStatus
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@SNUpdateMessage", [Data.SqlDbType]::VarChar, 500))).Value = $SNUpdateMessage
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@CallerId", [Data.SqlDbType]::VarChar, 500))).Value = $CallerId

    # Execute the command
    $command.ExecuteNonQuery()

    # Close the connection
    $connection.Close()
}
# Function to check allowed OUs agains users
function Test-AllowedOUs {
    param (
        [string]$UserDN, # The distinguished name of the user
        [string[]]$ParentOUs, # The list of parent OUs' distinguished names
        [string]$UserRank, # The Rnak of of the user
        [string]$Employmenttype # The employment type of the user
    )
    
    foreach ($parentOU in $ParentOUs) {
        if (($UserDN -like "*$parentOU*") -and ($employmenttype -like "VAR")){ # -and (($UserRank -like "staff") -or ($UserRank -like "Agent") -or ($UserRank -eq "-"))) {
            return $true
        }
    }

    return $false
}
# Function to generate a random password
function New-SimplePassword {
    # Define the pattern for password generation
    param(
        [string]$FirstName,
        [string]$LastName,
        [string]$NationalId
    )
    if ($NationalId.Length -lt 10) {
        while ($NationalId.Length -lt 10) {
            $NationalId = "0" + $NationalId
        }
    }
    $char1 = $FirstName.Trim().ToLower()[0]
    $char2 = $LastName.Trim().ToUpper()[0]
    $spChar = @('@', '#')[(Get-Random -Minimum 0 -Maximum 2)]
    $password = @("$($char1).$($char2)$($spChar)$($NationalId.Trim())", "$($NationalId.Trim())$($spChar)$($char2).$($char1)", "$($char2).$($char1)$($spChar)$($NationalId.Trim())", "$($NationalId.Trim())$($spChar)$($char1).$($char2)")[(Get-Random -Minimum 0 -Maximum 4)]
    return $password
}

function Send-AdminNotification {
    [CmdletBinding()]
    param (
        [string]$HookAddress,
        [string]$FactorUsed,
        [string]$factorValue,
        [string]$Date,
        [string]$Result,
        [string]$UserName,
        [string]$Details,
        [string]$Subject,
        [string]$CallerId
    )

    $body = @"
    {
        "blocks": [
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": "$Subject"
                }
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": ":keyboard:*By:*\n$CallerId"
                    },    
                    {
                        "type": "mrkdwn",
                        "text": ":second_place_medal:*Factor:*\n$FactorUsed"
                    },
                    {
                        "type": "mrkdwn",
                        "text": ":date:*When:*\n$Date"
                    },
                    {
                        "type": "mrkdwn",
                        "text": ":hash:*FactorValue:*\n$FactorValue"
                    },
                    {
                        "type": "mrkdwn",
                        "text": ":shit:*Results:*\n$Result"
                    },
                    {
                        "type": "mrkdwn",
                        "text": ":man-girl:*User:*\n $UserName"
                    }
                ]
            },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": ":incoming_envelope:Message: $Details"
                }
            }
        ]
    }
"@
    try {
        Invoke-WebRequest -Uri $HookAddress -Body $body -Method Post -ContentType "application/json"
    }
    catch {
        # nobody cares for missing an slack message!
    }
}


# Start Pode server
Start-PodeServer -Verbose {
    # Configure the server
    Add-PodeEndpoint -Address * -Port 8098 -Protocol Http
    # Add this to restrict server access
    # Add-PodeAccessRule -Access Allow -Type IP -Values @('127.0.0.1', '172.16.31.218', '172.16.31.222', '172.16.31.221')
    New-PodeLoggingMethod -File -Name Requests -MaxDays 14 | Enable-PodeRequestLogging
    New-PodeLoggingMethod -File -Name App -MaxSize 10MB | Enable-PodeErrorLogging -Levels Error, Informational, Warning

    # Add Authentication to protect reset routes
    Enable-PodeSessionMiddleware -Duration 360 -Extend
    New-PodeAuthScheme -Form | Add-PodeAuthWindowsAd -Name 'Admins' -Groups 'DWS.RstPwd.Portal Admins' -FailureUrl '/login' -SuccessUrl '/' -FailureMessage 'Username or Password is incorrect.'
    # Add-PodeAuthMiddleware -Name 'GlobalAuth' -Authentication 'Admins' -Route '/*'
    
    $DBConfig = (Get-PodeConfig).DBObject
    $AllowedOuDns = (Get-PodeConfig).AllowedOuDns
    $ThirdPartyApiKey = (Get-PodeConfig).ThirdPartyApiKey
    $SlackHook = (Get-PodeConfig).SlackIntegration["HookUrl"]

    Add-PodeRoute -Method Get -Path '/login' -ScriptBlock {
        # To debug request, un-comment: $webEvent | Export-Clixml ./Sample.xml -Force
        Write-PodeViewResponse -Path 'login.pode' -Data @{redir = $webEvent.Query['redir'] } -FlashMessages
    }

    # Logon and Logoff endpoints
    Add-PodeRoute -Method Post -Path '/login' -Authentication 'Admins' -Login
    Add-PodeRoute -Method Post -Path '/logout' -Authentication 'Admins' -Logout

    # Define route for the home page
    Add-PodeRoute -Method Get -Path '/' -Authentication 'Admins' -ScriptBlock {
        # To debug request, un-comment: 
        # $webEvent | Export-Clixml ./Sample.xml -Force
        Write-PodeViewResponse -Path 'index.pode' -Data @{
            redir = $webEvent.Query['redir'];
            Username = $WebEvent.Auth.User.Name;
    }
    }

    # Define route for password reset form submission
    Add-PodeRoute -Method Post -Path '/reset' -Authentication 'Admins' -ScriptBlock {
        # $webEvent | Export-Clixml ./ResetSample.xml -Force
        # Extract form data
        $username = $WebEvent.Data.username
        $factor = $WebEvent.Data.factor
        $factorValue = $WebEvent.Data.factorValue
        $clientIP = $WebEvent.Request.RemoteEndPoint
        $redirectUrl = $WebEvent.Query['redir']
        
        # Check if the user exists in AD
        try {
            $user = Get-ADUser -Identity $username -Properties NationalCode, empMob , mail , rank ,employmenttype -Verbose -ErrorAction Stop
            $UserEmailAddress = $user.mail
            # Verify user is allowed for self-service reset password
            if (-not (Test-AllowedOUs -UserDN $user.DistinguishedName -ParentOUs $using:AllowedOuDns -UserRank $user.Rank -Employmenttype $user.employmenttype )) {
                Send-EventToDB -Username $username -Status 'Failure' -FactorUsed $factor -IPAddress $clientIP `
                    -ErrorDetails "User is not in an allowed OU" -FactorValue $factorValue -DBObject $using:DBConfig -CallerId $WebEvent.Auth.User.Username
                Write-PodeViewResponse -Path 'error.pode' -Data @{ 
                    redir   = $redirectUrl
                    Message = "کاربر مجاز نیست!<br/>شما برای تغییر رمز عبور می‌بایست با دانستن رمز عبور کنونی، <a class=`"badge badge-danger`" href=`"https://dsso.adminfamily.com/adfs/portal/updatepassword?username=$($user.username)`"> از اینجا </a> نسبت به تغییر رمز خود اقدام نمایید. درصورتی که رمز عبور خود را نمی‌دانید، باید به تیم پشتیبانی آی‌تی مراجعه نمایید."
                    Username = $WebEvent.Auth.User.Name;
                }
                Send-AdminNotification -Subject ":fail:User Not Allowed" -HookAddress $using:SlackHook -FactorUsed $factor -factorValue $factorValue -Date (Get-Date).ToString() `
                    -Details $user.DistinguishedName -Result "Failed" -UserName $username -CallerId $WebEvent.Auth.User.Username
                return
            }

            # Verify the second factor
            if (($factor -eq 'PhoneNumber' -and $user.empMob -eq $factorValue) -or ($factor -eq 'NationalCode' -and $user.NationalCode -eq $factorValue)) {
                # Generate a new password
                $newPassword = New-SimplePassword -FirstName $user.GivenName -LastName $user.Surname -NationalId $user.NationalCode
                
                # Set the new password in AD (requires appropriate permissions)
                Set-ADAccountPassword -Identity $user.DistinguishedName -Reset -NewPassword (ConvertTo-SecureString $newPassword -AsPlainText -Force) -ErrorAction Stop -Verbose
                Write-PodeHost "$UserEmailAddress" ,  "$newPassword"
                $SNResponse = Set-ThirdPartyPassword -email $UserEmailAddress -password $newPassword -ApiKey $using:ThirdPartyApiKey
                Write-PodeHost "SNResponse : $SNResponse"
                Send-EventToDB -Username $username -Status 'Success' -FactorUsed $factor -IPAddress $clientIP `
                    -DBObject $using:DBConfig -FactorValue $factorValue -SNUpdateStatus $SNResponse.Status -SNUpdateMessage $SNResponse.error_message  -CallerId $WebEvent.Auth.User.Username

                    $SNResponse | Out-PodeHost
                    $SNResponse.status -ne 'Success' | Out-PodeHost
                if ($SNResponse.status -ne 'Success') {
                    Send-AdminNotification -Subject ":fail:SN Pass Update failed!" -HookAddress $using:SlackHook -FactorUsed $factor -factorValue $factorValue -Date $WebEvent.Timestamp `
                        -Details "The users Password has changed in AD, but failed to change in ThirdParty.\n*ThirdParty Status*:$($SNResponse.status)\n*ThirdParty Message*:$($SNResponse.error_message -Replace '"','')" -Result "Success" -UserName $username -CallerId $WebEvent.Auth.User.Username
                }

                Write-PodeViewResponse -Path 'success.pode' -Data @{ 
                    redir    = $redirectUrl
                    Password = $newPassword
                    Username = $WebEvent.Auth.User.Name
                    NationalCode = $user.NationalCode
                }
                Send-AdminNotification -Subject ":white_check_mark:Password Changed" -HookAddress $using:SlackHook -FactorUsed $factor -factorValue $factorValue -Date $WebEvent.Timestamp `
                 -Result "Success" -UserName $username -CallerId $WebEvent.Auth.User.Username

            }
            else {
                # Determine the factor type and construct the appropriate error message
                $errorMessage = if ($factor -eq 'PhoneNumber') {
                    "مقدار شماره موبایل '$factorValue' وارد شده صحیح نیست! لطفا شماره موبایل ثبت شده در سیستم منابع انسانی را به دقت وارد نمایید."
                }
                elseif ($factor -eq 'NationalCode') {
                    "مقدار کد ملی '$factorValue' وارد شده صحیح نیست! لطفا کد ملی ثبت شده در سیستم منابع انسانی را به دقت وارد نمایید."
                }
                else {
                    "مقدار وارد شده صحیح نیست! لطفا از بین کد ملی یا شماره موبایل ثبت شده در سیستم منابع انسانی، یکی را با دقت انتخاب کرده و مقدار صحیح را وارد نمایید."
                }
            
                # Log the failure event to the database
                Send-EventToDB -Username $username -Status 'Failure' -FactorUsed $factor -IPAddress $clientIP `
                    -ErrorDetails "Incorrect Factor Value" -FactorValue $factorValue -DBObject $using:DBConfig -CallerId $WebEvent.Auth.User.Username
            
                # Display the error message
                Write-PodeViewResponse -Path 'error.pode' -Data @{ 
                    redir   = $redirectUrl
                    Message = $errorMessage
                    Username = $WebEvent.Auth.User.Name
                }
                Send-AdminNotification -Subject ":fail:Incorrect Factor Value" -HookAddress $using:SlackHook -FactorUsed $factor -factorValue $factorValue -Date $WebEvent.Timestamp `
                    -Details "This might be an incident of an abuse, as well\nIPAddress: $($clientIP)\n$($WebEvent.Request.UserAgent)" -Result "Failed" -UserName $username -CallerId $WebEvent.Auth.User.Username
                return
            }
            
        }
        catch {
            # Log failure
            $errorMessage = $_.Exception.Message | Out-String
            if ($SNResponse) {
                Send-EventToDB -Username $username -Status 'Failure' -FactorUsed $factor -IPAddress $clientIP `
                    -ErrorDetails "$($errorMessage)" -FactorValue $factorValue -DBObject $using:DBConfig -SNUpdateStatus $SNResponse.Status -SNUpdateMessage $SNResponse.error_message -CallerId $WebEvent.Auth.User.Username
            }
            else {
                Send-EventToDB -Username $username -Status 'Failure' -FactorUsed $factor -IPAddress $clientIP `
                    -ErrorDetails "$($errorMessage)" -FactorValue $factorValue -DBObject $using:DBConfig -CallerId $WebEvent.Auth.User.Username
            }
            # Display error message
            Write-PodeViewResponse -Path 'error.pode' -Data @{ Message = "خطای سیستمی رخ داد!<br/>لطفا نام کاربری را با دقت وارد نموده و مجددا تلاش کنید. درصورتی که این خطا مجددا رخ داد، برای دریافت نام کاربری خود به سرپرست خود یا واحد پشتیبانی آی‌تی مراجعه نمایید." ;redir = $WebEvent.Query['redir'];Username = $WebEvent.Auth.User.Name;}
            Send-AdminNotification -Subject ":fail:System Error" -HookAddress $using:SlackHook -FactorUsed $factor -factorValue $factorValue -Date $WebEvent.Timestamp `
                -Details $errorMessage -Result "Failed" -UserName $username -CallerId $WebEvent.Auth.User.Username
        }
    }
}