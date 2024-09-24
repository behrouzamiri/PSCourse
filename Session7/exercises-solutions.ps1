function New-Employee {
    <#
    .SYNOPSIS
    Creates a new employee entry in the system.

    .DESCRIPTION
    The `New-Employee` function adds a new employee record by either manually specifying the hire date and salary 
    or automatically setting default values for new joiners. The function ensures that no duplicate employee names 
    exist in the system by querying an existing employee list from an external API.

    .PARAMETER DateHired
    Specifies the date when the employee was hired. This parameter is part of the "manualentry" parameter set. 
    If not specified and `-IsNewJoiner` is used, today's date will be assigned.

    .PARAMETER Salary
    Specifies the salary of the employee. This parameter is part of the "manualentry" parameter set. 
    If not specified and `-IsNewJoiner` is used, a default salary of 120,000 will be assigned.

    .PARAMETER Expertise
    Specifies the expertise or job role of the employee. This is a mandatory parameter that must be provided in both 
    manual and automatic parameter sets.

    .PARAMETER Department
    Specifies the department where the employee will be working. This is an optional parameter. If not provided, 
    the employee's department will not be set in the system.

    .PARAMETER Name
    Specifies the name of the employee. The function validates the uniqueness of the name by checking against 
    existing employee names through an API call. If the name is already in use, the function throws an error.

    .PARAMETER IsNewJoiner
    This switch is used when adding a new joiner automatically. When this switch is set, the `DateHired` will 
    default to today's date, and the `Salary` will default to 120,000. This is part of the "automaticentry" 
    parameter set.

    .EXAMPLE
    New-Employee -Name "John Doe" -Expertise "Software Developer" -Department "IT" -DateHired "2022-01-15" -Salary 100000

    This adds a new employee named "John Doe" to the IT department with a specified hire date and salary.

    .EXAMPLE
    New-Employee -Name "Jane Smith" -Expertise "Marketing Manager" -IsNewJoiner

    This adds a new joiner named "Jane Smith" to the system, automatically setting the hire date to today's date 
    and assigning a default salary of 120,000.

    .NOTES
    Author: Behrouz Amiri
    VersionCompatibility: This function works with the v1.0.0 API of the psdemo system.
    ImportantNotes: This function interacts with an external REST API to add employee records.
    If the name already exists in the system, an error will be thrown, and the employee will not be added.

    .LINK
    https://psdemo.adminfamily.com/swagger
    #>

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

# the above function is part of the answer. the full answer will be available before session 8.