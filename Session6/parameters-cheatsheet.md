# PowerShell `param()` Block Cheatsheet

The `param()` block in PowerShell functions is used to define parameters that the function accepts. This block allows you to control the input to your functions by specifying types, default values, validation, and more.

## 1. Basic Syntax

```powershell
function My-Function {
    param (
        [Parameter()]
        [string]$Name
    )
    # Function code here
}
```

---

## 2. Mandatory Parameters

To make a parameter required, use the `Mandatory` attribute.

```powershell
param (
    [Parameter(Mandatory=$true)]
    [string]$Name
)
```

- **Example**: The function will prompt for `$Name` if not provided when the function is called.

---

## 3. Default Values

You can assign default values to parameters, which will be used if the caller does not provide a value.

```powershell
param (
    [string]$Name = "John Doe"
)
```

- **Example**: If no value is passed, `$Name` will default to "John Doe".

---

## 4. Data Types

You can specify a parameter’s data type to control what kind of input the function accepts.

```powershell
param (
    [int]$Age,
    [string]$Name
)
```

- **Example**: `$Age` must be an integer, and `$Name` must be a string.

---

## 5. Parameter Sets

Parameter sets allow you to define different sets of parameters that cannot be used together, enforcing different behaviors.

```powershell
param (
    [Parameter(ParameterSetName="ByName")]
    [string]$Name,

    [Parameter(ParameterSetName="ByID")]
    [int]$ID
)
```

- **Example**: You can pass either `-Name` or `-ID`, but not both.

---

## 6. Accepting Pipeline Input

To accept values from the pipeline, use the `ValueFromPipeline` attribute.

```powershell
param (
    [Parameter(ValueFromPipeline=$true)]
    [string]$Name
)
```

- **Example**: Allows the function to accept input directly from a pipeline.

---

## 7. Validating Parameters

### 7.1 ValidateNotNullOrEmpty

Ensures the parameter is not `$null` or an empty string.

```powershell
param (
    [ValidateNotNullOrEmpty()]
    [string]$Name
)
```

### 7.2 ValidateRange

Restricts the value to a specified numeric range.

```powershell
param (
    [ValidateRange(1, 100)]
    [int]$Age
)
```

- **Example**: `$Age` must be between 1 and 100.

### 7.3 ValidateSet

Restricts input to a set of predefined values.

```powershell
param (
    [ValidateSet("Red", "Green", "Blue")]
    [string]$Color
)
```

- **Example**: `$Color` must be one of "Red", "Green", or "Blue".

### 7.4 ValidateScript

Validates the parameter with a custom script block.

```powershell
param (
    [ValidateScript({
        if ($_ -lt 18) {
            throw "Age must be at least 18."
        }
        return $true
    })]
    [int]$Age
)
```

- **Example**: The script ensures that `$Age` is at least 18.

---

## 8. Aliasing Parameters

You can define aliases for parameters using the `Alias` attribute.

```powershell
param (
    [Alias("FN")]
    [string]$FirstName
)
```

- **Example**: The parameter `$FirstName` can also be passed using the alias `-FN`.

---

## 9. Using `Switch` Parameters

A `switch` is a Boolean parameter that does not require a value. It is either present (`$true`) or absent (`$false`).

```powershell
param (
    [switch]$Verbose
)
```

- **Example**: If `-Verbose` is used, `$Verbose` will be `$true`; otherwise, `$false`.

---

## 10. Parameter Position

By default, parameters can be passed by name. You can also specify their position in the command line.

```powershell
param (
    [Parameter(Position=0)]
    [string]$Name,

    [Parameter(Position=1)]
    [int]$Age
)
```

- **Example**: In this case, `$Name` is the first argument, and `$Age` is the second.

---

## 11. Handling Multiple Values (Array Parameters)

To accept multiple values for a parameter, define it as an array.

```powershell
param (
    [string[]]$Names
)
```

- **Example**: You can pass multiple values like `-Names "Alice", "Bob", "Charlie"`.

---

## 12. Dynamic Parameters

Dynamic parameters are created at runtime and are only available under certain conditions.

```powershell
function Get-Data {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Query
    )
    DynamicParam {
        $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary

        if ($Query -eq "User") {
            $Attrib = New-Object System.Management.Automation.ParameterAttribute
            $Attrib.Mandatory = $true
            $rparam = New-Object System.Management.Automation.RuntimeDefinedParameter('UserID', [string], $Attrib)
            $paramDictionary.Add('UserID', $rparam)
        }

        return $paramDictionary
    }
}
```

- **Example**: `UserID` will only be a parameter if `$Query` is "User".

---

## 13. `$PSCmdlet` and `$PSBoundParameters`

### `$PSCmdlet`

The `$PSCmdlet` automatic variable provides access to cmdlet-specific information such as the parameter set being used.

```powershell
if ($PSCmdlet.ParameterSetName -eq "SetA") {
    Write-Host "Using Parameter Set A"
}
```

### `$PSBoundParameters`

`$PSBoundParameters` contains a dictionary of all the parameters that were explicitly passed.

```powershell
if ($PSBoundParameters.ContainsKey('Name')) {
    Write-Host "The Name parameter was provided."
}
```

---

## 14. Error Handling in Parameters

To ensure a function gracefully handles errors related to parameters, you can wrap your parameter processing in a `try-catch` block.

```powershell
param (
    [Parameter(Mandatory=$true)]
    [string]$Path
)

try {
    if (-not (Test-Path $Path)) {
        throw "Path '$Path' does not exist."
    }
} catch {
    Write-Error $_
}
```

---

## Summary

The `param()` block is a powerful tool for making your PowerShell functions more flexible, robust, and user-friendly. With validation, parameter sets, and pipeline input, you can ensure that your functions behave as expected while handling a variety of use cases.
