# Session 6: PowerShell Functions

## Overview

In this session, we will focus on PowerShell **functions**, covering everything from simple to advanced usage. Functions are a key component of writing reusable, modular scripts. We will explore function definitions, parameters, and work through advanced examples like writing logs and sending formatted emails.

### Topics Covered
1. **Function Definition and Use Case**
2. **Function Syntax**
3. **Function Parameters (Simple)**
4. **Function Parameters (Advanced)**
   - 4.1 Parameter Validation
   - 4.2 Parameter Sets
   - 4.3 Important Automatic Variables in Functions
5. **Example Function: New-Employee**
6. **Practice Section**

---

## 1. Function Definition and Use Case

A **function** in PowerShell is a named block of code that performs a specific task. Functions are useful because they can be reused multiple times within scripts, making code modular and maintainable.

- **Use Case**: Functions can be used for repetitive tasks, such as retrieving data, formatting output, or performing calculations.
- **Benefits**: 
  - Reusability
  - Modularity
  - Easier maintenance

---

## 2. Function Syntax

A basic function in PowerShell is defined with the `function` keyword followed by the function name and a script block that contains the code.

- **Basic Syntax**:
    ```powershell
    function FunctionName {
        # Code block
    }
    ```
  
- **Example**:
    ```powershell
    function Get-DateInFormat {
        $date = Get-Date
        return $date.ToString('yyyy-MM-dd')
    }

    # Calling the function
    Get-DateInFormat
    ```

---

## 3. Function Parameters (Simple)

Parameters allow a function to accept input. PowerShell functions use the `param` block to define parameters.

- **Simple Parameters Syntax**:
    ```powershell
    function Get-Greeting {
        param (
            [string]$Name
        )
        Write-Host "Hello, $Name!"
    }

    # Calling the function
    Get-Greeting -Name "John"
    ```

- **Example**:
    ```powershell
    function Add-Numbers {
        param (
            [int]$a,
            [int]$b
        )
        return $a + $b
    }

    # Calling the function
    Add-Numbers -a 10 -b 20
    ```

---

## 4. Function Parameters (Advanced)

In more advanced scenarios, PowerShell functions can use parameter validation, default values, and **parameter sets** to control the behavior of the function. 

### 4.1 Parameter Validation

PowerShell provides validation attributes to enforce specific conditions on parameters (e.g., mandatory input, valid range).

- **Example**:
    ```powershell
    function Set-Age {
        param (
            [int]$Age,
            [ValidateRange(1, 120)]
            [int]$ValidatedAge
        )
        Write-Host "Your age is: $Age"
        Write-Host "Validated Age: $ValidatedAge"
    }

    # Calling the function
    Set-Age -Age 30 -ValidatedAge 150 # This will throw an error due to the validation
    ```

### 4.2 Parameter Sets

Parameter sets allow you to define different sets of parameters that can be used to change the behavior of the function.

- **Example**:
    ```powershell
    function Get-UserInfo {
        param (
            [parameter(ParameterSetName="ByUsername")]
            [string]$Username,

            [parameter(ParameterSetName="ByID")]
            [int]$UserID
        )
        
        if ($PSCmdlet.ParameterSetName -eq "ByUsername") {
            Write-Host "Getting info for user: $Username"
        } elseif ($PSCmdlet.ParameterSetName -eq "ByID") {
            Write-Host "Getting info for user ID: $UserID"
        }
    }

    # Calling the function
    Get-UserInfo -Username "JohnDoe"
    ```

### 4.3 Important Automatic Variables in Functions

PowerShell provides several **automatic variables** that are available inside functions and help control function execution or provide useful information.

- **Common Automatic Variables**:
    - **`$PSCmdlet`**: Represents the cmdlet being run. Provides access to parameters, parameter sets, and more.
    - **`$Args`**: Contains all arguments that are passed to the function that were not bound to declared parameters.
    - **`$Error`**: A global variable that stores an array of error records generated by the script.
    - **`$PSBoundParameters`**: A dictionary that stores only the parameters that were explicitly provided in the function call.

- **Examples**:

    **Example 1**: Using `$PSCmdlet` to check parameter set.
    ```powershell
    function Test-PSCmdlet {
        param (
            [Parameter(ParameterSetName="SetA")]
            [string]$ParamA,

            [Parameter(ParameterSetName="SetB")]
            [string]$ParamB
        )

        if ($PSCmdlet.ParameterSetName -eq "SetA") {
            Write-Host "Using Parameter Set A"
        } elseif ($PSCmdlet.ParameterSetName -eq "SetB") {
            Write-Host "Using Parameter Set B"
        }
    }

    Test-PSCmdlet -ParamA "Hello"
    ```

    **Example 2**: Using `$PSBoundParameters` to verify provided parameters.
    ```powershell
    function Test-BoundParams {
        param (
            [string]$FirstName,
            [string]$LastName
        )

        if ($PSBoundParameters.ContainsKey('FirstName')) {
            Write-Host "First name provided: $FirstName"
        }

        if ($PSBoundParameters.ContainsKey('LastName')) {
            Write-Host "Last name provided: $LastName"
        }
    }

    Test-BoundParams -FirstName "John"
    ```

---

## 5. Example Function: New-Employee

Now that we've covered parameters, here's an example of a more complex function that creates a new employee. This function includes:

- **Parameter sets**: To handle manual and automatic entry modes.
- **Validation script**: To check for duplicate employee names.

```powershell
function New-Employee {
    param (
        [parameter(ParameterSetName="manualentry")]
        [datetime]$DateHired,
        [parameter(ParameterSetName="manualentry")]
        [int]$Salary,
        [Parameter(Mandatory)][string]$Expertise,
        [string]$Department,
        [string][Validatescript({
            if($_ -in (Invoke-RestMethod -Method Get 'https://psdemo.adminfamily.com/api/v1/employees').Name){
                throw 'Duplicate Employee'
            }
            else {
                return $true
            }
        })]
        $Name,
        [parameter(ParameterSetName="automaticentry")]
        [switch]$IsNewJoiner
    )

    if ($IsNewJoiner) {
        $DateHired = (Get-Date).Date
        $Salary = 120000
    }

    $body = @{
        "DateHired"  = $DateHired.ToString()
        "Salary"     = $Salary
        "Expertise"  = $Expertise
        "Department" = $Department
        "Name"       = $Name
    } | ConvertTo-Json

    Invoke-RestMethod -Method Post -Uri 'https://psdemo.adminfamily.com/api/v1/employees' -Body $body -ContentType 'application/json'
}

# Calling the function with automatic entry
New-Employee -IsNewJoiner -Expertise "Software Engineer" -Name "Jane Doe" -Department "IT"
```

## 6. Practice Section

### 6.1 Example Function: `Write-LogMessage`
This function writes a log entry into a file named <yyyy-MM-dd>.log in the current directory. It supports the following:

a. Logging with a timestamp and log type (Info, Warning, Error).
b. Optionally writes debug objects (stored in another file as a .guid file with the same name as the log).

```powershell
function Write-LogMessage {
    param (
        [Parameter(Mandatory)][ValidateSet('Info', 'Warning', 'Error')]
        [string]$Type,
        
        [Parameter(Mandatory)]
        [string]$Message,
        
        [Parameter()]
        [array]$DebugObjects
    )
    
    # Generate log file name
    $logFile = (Get-Date -Format "yyyy-MM-dd") + ".log"
    $timestamp = Get-Date -Format "HH:mm:ss.fff"
    
    # Write the log message
    "$timestamp [$Type] $Message" | Out-File -Append -FilePath $logFile
    
    # Handle debug objects
    if ($DebugObjects) {
        $guidFileName = [guid]::NewGuid().ToString() + ".guid"
        foreach ($obj in $DebugObjects) {
            $obj | Out-String | Out-File -Append -FilePath $guidFileName
        }
        "$timestamp [Debug] Objects logged in $guidFileName" | Out-File -Append -FilePath $logFile
    }
}

# Usage example
Write-LogMessage -Type "Info" -Message "This is a test log entry" -DebugObjects @($obj1, $obj2)
```

### 6.2 Example Function: `Send-FormattedEmail`

This function sends a formatted HTML email using an SMTP server and port 587. It converts PowerShell objects into an HTML table, allowing both singular objects (as key-value pairs) and arrays of objects (as rows) to be sent as formatted tables.

```powershell
function Send-FormattedEmail {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        
        [Parameter(Mandatory)]
        [psobject]$Object,

        [Parameter(Mandatory)]
        [PSCredential]$Credential,

        [Parameter(Mandatory)]
        [string]$SmtpServer,

        [Parameter(Mandatory)]
        [string]$From,

        [Parameter(Mandatory)]
        [string]$Recipient = "recipient@example.com",

        [Parameter()]
        [string]$Subject = "Formatted Email"
    )

    # Start building the HTML email body with themed colors
    $htmlBody = @"
    <html>
        <body style='font-family: Arial, sans-serif; color: #333;'>
            <div style='background-color: #f9f9f9; padding: 15px; border: 1px solid #ddd;'>
                <h2 style='color: #007acc;'>$Message</h2>
                <table border='1' cellpadding='8' cellspacing='0' style='border-collapse: collapse; width: 100%;'>
"@

    if ($Object -is [array]) {
        # Add table headers if multiple objects are passed
        $headers = ($Object[0].PSObject.Properties | ForEach-Object { $_.Name }) -join "</th><th>"
        $htmlBody += "<thead><tr style='background-color: #007acc; color: white;'><th>$headers</th></tr></thead>"
        
        # Add table rows for each object
        foreach ($item in $Object) {
            $row = ($item.PSObject.Properties | ForEach-Object { $_.Value }) -join "</td><td>"
            $htmlBody += "<tr style='background-color: #f2f2f2; color: #333;'><td>$row</td></tr>"
        }
    } else {
        # Single object - key-value table
        foreach ($property in $Object.PSObject.Properties) {
            $htmlBody += "<tr style='background-color: #f2f2f2; color: #333;'><td><b style='color: #007acc;'>$($property.Name)</b></td><td>$($property.Value)</td></tr>"
        }
    }

    # Close HTML tags
    $htmlBody += @"
                </table>
            </div>
        </body>
    </html>
"@

    # Send email using SMTP
    Send-MailMessage -To $Recipient -From $From -Subject $Subject `
        -Body $htmlBody -BodyAsHtml -SmtpServer $SmtpServer -Port 587 -Credential $Credential
}

# Usage example
$employee = Get-EmployeeDetails
Send-FormattedEmail -Message "Here is the employee data:" -Object $employee -Credential (Get-Credential) -SmtpServer "smtp.example.com"
```

## 7. Conclusion
This session has covered:

The fundamentals of function creation in PowerShell.
How to work with both simple and advanced function parameters, including parameter sets.
Practical, advanced examples like logging and sending formatted emails with custom HTML.
A variety of exercises to solidify your understanding.
**Continue practicing by writing your own functions and expanding on these concepts to master PowerShell scripting!**