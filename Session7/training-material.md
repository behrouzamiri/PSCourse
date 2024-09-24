# Session 7: Advanced PowerShell Functions and Modules

## Overview

In this session, we will dive deeper into writing **function help** in PowerShell, explore **modules and components**, learn how to use **.NET DLLs** with PowerShell (with a real-world example), and continue practicing with more advanced functions.

### Topics Covered
1. **Writing Help for Functions**
2. **PowerShell Modules and Components**
3. **Advanced Function Practices**

---

## 1. Writing Help for Functions

Writing help content for your functions makes them easier to use for others and for yourself. PowerShell allows you to add detailed help information to your functions using comment-based help.
Help content, usually has below sections:
- SYNOPSYS
- DESCRIPTION
- PARAMETER
- EXAMPLE
- NOTES

### 1.1 Comment-Based Help Syntax

```powershell
function Get-SampleData {
    <#
    .SYNOPSIS
    Gets sample data from a data source.

    .DESCRIPTION
    The `Get-SampleData` function retrieves data from a pre-configured data source
    and returns the result in an object format. This function demonstrates how to retrieve data
    and format it for processing in PowerShell.

    .PARAMETER Source
    The source of the data to retrieve. It could be a file path or a URL.

    .EXAMPLE
    Get-SampleData -Source "C:\data\sample.json"

    Retrieves data from the specified file.

    .EXAMPLE
    Get-SampleData -Source "https://example.com/api/data"

    Retrieves data from the specified URL.

    .NOTES
    Author: Your Name
    Version: 1.0
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$Source
    )

    # Function code here
}
```

### 1.2 Accessing Function Help

Once the help is added, you can access it using the `Get-Help` command.

```powershell
Get-Help Get-SampleData -Full
```

### 1.3 Important Help Sections

- `.SYNOPSIS`: A brief description of what the function does.
- `.DESCRIPTION`: A more detailed explanation of the function's behavior.
- `.PARAMETER`: Description of each parameter.
- `.EXAMPLE`: One or more examples of how to use the function.
- `.NOTES`: Additional information such as the author or version.

---

## 2. PowerShell Modules and Components

Modules in PowerShell allow you to package functions, variables, and other resources so they can be reused across different scripts and systems.

### 2.1 What is a PowerShell Module?

A **module** is a package that contains PowerShell code, such as functions, cmdlets, or variables, that can be imported into a session for reuse.

- Modules can be written as:
  - **Script Modules** (`.psm1`)
  - **Binary Modules** (`.dll`)
  - **Manifest Files** (`.psd1`)

### 2.2 Creating a Simple Script Module

A script module is a collection of PowerShell functions saved in a `.psm1` file. Here’s how you can create one:

1. **Create a Directory** for your module:
   ```powershell
   mkdir C:\MyModules\MyModule
   ```

2. **Write Functions in a .psm1 File**:
   Save the following code in a file named `MyModule.psm1` inside the `MyModule` directory.

   ```powershell
   function Get-Greeting {
       param ([string]$Name)
       "Hello, $Name!"
   }

   function Add-Numbers {
       param ([int]$a, [int]$b)
       return $a + $b
   }
   ```

3. **Import the Module** in your session:
   ```powershell
   Import-Module C:\MyModules\MyModule\MyModule.psm1
   ```

4. **Exporting Functions**: By default, all functions in the module are available. You can limit what gets exported using the `Export-ModuleMember` cmdlet.

   ```powershell
   Export-ModuleMember -Function Get-Greeting
   ```

   **Why would you not export a module member?** 
   You may have helper functions that are used internally within the module but aren’t intended to be called directly by users of the module. By only exporting the public functions, you can encapsulate complexity and avoid cluttering the user’s environment with unnecessary functions.

### 2.3 Module Manifest (`.psd1`)

A **manifest file** is a metadata file for your module. It describes your module's components, author, version, dependencies, and much more. It is created using `New-ModuleManifest`.

```powershell
New-ModuleManifest -Path C:\MyModules\MyModule\MyModule.psd1 -RootModule MyModule.psm1 -Author "Your Name" -Description "A simple example module."
```

### 2.4 Installing Modules

Once you've created a module, you can **install** it by placing it in one of the module paths.

```powershell
$env:PSModulePath
```

To make the module available to all users, place it in `C:\Program Files\WindowsPowerShell\Modules\`.

---

## 3. More Practice: Functions and Modules

### 3.1 Practice: Adding Function Help

Create a function that converts temperatures between Celsius and Fahrenheit, and write a proper help block for it.

```powershell
function Convert-Temperature {
    <#
    .SYNOPSIS
    Converts a temperature between Celsius and Fahrenheit.

    .PARAMETER Temperature
    The temperature to convert.

    .PARAMETER ToCelsius
    Converts to Celsius if specified. If omitted, it converts to Fahrenheit.

    .EXAMPLE
    Convert-Temperature -Temperature 100 -ToCelsius

    Converts 100°F to Celsius.

    .EXAMPLE
    Convert-Temperature -Temperature 37

    Converts 37°C to Fahrenheit.

    #>
    param (
        [double]$Temperature,
        [switch]$ToCelsius
    )

    if ($ToCelsius) {
        return ($Temperature - 32) * 5 / 9
    } else {
        return ($Temperature * 9 / 5) + 32
    }
}
```

### 3.2 Practice: Building a Module

Create a module that contains functions for basic math operations (e.g., addition, subtraction, multiplication, division) and write a manifest for it.

### 3.3 Using the Library in PowerShell

When you Import DLL, you can call its methods directly from PowerShell. Here's an example of using the `PersianTools` library to convert a Gregorian date to Persian format:

```powershell
# Using Persia.Net to convert Gregorian date to Persian date
$gregorianDate = Get-Date
$persianDate = [Persia.Calendar]::ConvertToPersian($gregorianDate)
$persianDate.Persian
```

You can wrap this functionality into a PowerShell function for easier reuse:

### 3.3 Wrapping the DLL in a PowerShell Function

```powershell
 
function Get-PersianDate {
    [CmdletBinding(DefaultParameterSetName = 'DateObject')]
    param (
        [Parameter(Mandatory = $false,
            ParameterSetName = 'DateObject',
            HelpMessage = 'Pass a DateTime Object',
            Position = 0)]
        [datetime]$DateObject,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Splitted',
            HelpMessage = 'Specify Year, Month and Day',
            Position = 0)]
        [int]$Year,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'Splitted',
            HelpMessage = 'Specify Year, Month and Day',
            Position = 1)]
        [int]$Month = 0,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'Splitted',
            HelpMessage = 'Specify Year, Month and Day',
            Position = 2)]
        [int]$Day = 0,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'String',
            HelpMessage = 'Specify date as string',
            Position = 0)]
        [string]$Date,

        [switch]$PrettyOut
    )
    # Load the Assembly first
    [System.Reflection.Assembly]::LoadFrom("C:\Data\Code\PersianCalendar\PersianTools.Core.dll") | Out-Null
    $c = [PersianTools.Core.PersianDateTime]::new
    
    if ($DateObject) {
        $output = [PersianTools.Core.PersianDateExtensions]::ToShamsiDateTime($DateObject)
    }

    if ((!$Year) -and (!$DateObject)) {
        $output = [PersianTools.Core.PersianDateExtensions]::ToShamsiDateTime((Get-Date))
    }

    if ($Year -and (!$Date)) {
        $output = $c.invoke($Year, $Month, $Day);
    }
    if($Date -and (!$Year) -and (!$DateObject)){
        if($Date.Contains('/')){
        $output = $c.Invoke($Date)
        }
    }

    if ($PrettyOut) {
        return "$($output.DayOfWeek), $($output.Day) $($output.MonthOfYear) $($output.Year) - ساعت $($output.Hour):$($output.Minute):$($output.Second)"
    }
    else {
        return $output
    }
} 


# Example usage
Get-PersianDate -DateObject (Get-Date)  # Output: Persian date string
 DateTime      : 9/24/2024 1:08:08 PM
Millisecond   : 941
Second        : 8
Minute        : 8
Hour          : 13
Day           : 3
Month         : 7
Year          : 1403
DayOfWeek     : سه شنبه
MonthOfYear   : مهر
ShamsiDate    : 1403/07/03
TimeOfDay     : 13:08:08.9410996
DateMetaDatas : {}
HijriDate     : PersianTools.Core.HijriDate
IsHoliDay     : False
 

```

This example demonstrates how using an external .NET DLL can extend PowerShell's capabilities and be packaged into a reusable function.


---

## Conclusion

In Session 7, we’ve explored:

1. **Writing Help for Functions**: How to document PowerShell functions with comment-based help.
2. **PowerShell Modules**: Creating script modules and understanding the purpose of manifest files.
3. **Using .NET DLLs**: Loading and using the **Persia.Net** library from GitHub to extend PowerShell's capabilities.
4. **Practice**: Exercises to reinforce concepts like function documentation and module creation.

---

By the end of this session, your students will have a deeper understanding of documenting functions, working with modules, and integrating external .NET assemblies in their PowerShell scripts.
