# Session 5: Advanced Flow Control and Error Handling in PowerShell

## Overview

In this session, we will explore advanced flow control techniques and error handling in PowerShell. The goal is to deepen your understanding of how to manage complex scripts and handle errors gracefully. We will also include practical exercises to apply these concepts.

## From Previous Sessions:

### For Loop

```powershell
for ($i = 0; $i -lt 5; $i++) {
    Write-Output "Iteration $i"
}
```

### While Loop

```powershell
while(Condition){ # be careful about condition, because this can cause infinit loop
    DoSomething
}
```

### ForEach Loop

```powershell
Foreach ($item in $items){
    DoSomething
}
```

### PS Custom Object

```powershell
$obj = New-Object -TypeName pscustomobject # Then Add members like this:
$obj | Add-Member -NotePropertyName "Experties" -NotePropertyValue "IT"
# OR
$obj = [pscustomobject]@{
    Name = "Behrouz"
    Age = "38"
    Weight = "78"
}

$obj.GetType() # PSCustomObject
```

### Topics Covered

1. **Flow Control:**

   - `switch` Statements
   - `do-while` Loops # read on your own! also about do-until
   - `Continue` and `Break` Statements for Flow management

2. **Error Handling:**

   - `try-catch-finally` Blocks

3. **Practice Section:**
   - Interactive exercises using the concepts learned.

## 1. Flow Control in PowerShell

### 1.1 `switch` Statement

- **Definition**: The `switch` statement evaluates an expression against a list of conditions (cases) and executes the code block corresponding to the first matching case.
- **Syntax**:
  ```powershell
  switch (expression) {
      condition1 { # Code block }
      condition2 { # Code block }
      Default { # Code block if no match }
  }
  ```
- **Example**:
  ```powershell
  $day = Read-Host -Prompt "Enter a day of the week"
  switch ($day) {
      "Monday" { "Start of the work week." }
      "Friday" { "Almost weekend!" }
      "Saturday" { "Weekend!" }
      "Sunday" { "Weekend!" }
      Default { "Just another day." }
  }
  ```

### 1.2 `do-while` Loop

- **Definition**: The `do-while` loop executes a block of code at least once and then repeats the loop as long as a specified condition is true.
- **Syntax**:
  ```powershell
  do {
      # Code block
  } while (condition)
  ```
- **Example**:
  ```powershell
  $count = 0
  do {
      Write-Host "Count is $count"
      $count++
  } while ($count -lt 5)
  ```

### 1.3 Continue and Break Statements

In PowerShell, `break` and `continue` are control flow statements used to manage the execution of loops. They allow you to exit or skip parts of a loop based on certain conditions.

#### Break

- **Definition**: The `break` statement immediately terminates the loop in which it is used. The control flow then continues with the statement following the loop.
- **Use Case**: Use `break` when you need to exit a loop early, such as when a specific condition is met.

- **Syntax**:

  ```powershell
  break
  ```

- **Example**:
  ```powershell
  foreach ($i in 1..10) {
      if ($i -eq 5) {
          break
      }
      Write-Host "Number: $i"
  }
  ```
  **Output**:
  ```
  Number: 1
  Number: 2
  Number: 3
  Number: 4
  ```
  In this example, the loop terminates when `$i` equals 5, so the numbers after 4 are not printed.

#### Continue

- **Definition**: The `continue` statement skips the remaining code in the current iteration of the loop and proceeds to the next iteration.
- **Use Case**: Use `continue` when you want to skip certain iterations based on a condition but continue looping.

- **Syntax**:

  ```powershell
  continue
  ```

- **Example**:
  ```powershell
  for ($i = 1; $i -le 10; $i++) {
      if ($i % 2 -eq 0) {
          continue
      }
      Write-Host "Odd Number: $i"
  }
  ```
  **Output**:
  ```
  Odd Number: 1
  Odd Number: 3
  Odd Number: 5
  Odd Number: 7
  Odd Number: 9
  ```
  In this example, the loop prints only odd numbers because the `continue` statement skips the rest of the loop body when `$i` is even.

### Practical Application

- **Example**: Loop through a list of employees and stop when a certain condition is met (using `break`) or skip certain employees based on a condition (using `continue`).

````powershell
$employees = Invoke-RestMethod -Uri "https://psdemo.adminfamily.com/api/v1/employees"
foreach ($employee in $employees) {
    if ($employee.Department -eq "HR") {
        continue  # Skip employees in the HR department
    }

    Write-Host "Processing employee: $($employee.Name)"

    if ($employee.Salary -gt 200000) {
        Write-Host "Found an employee with a salary over $200,000. Stopping process."
        break  # Exit the loop when an employee with a salary over $200,000 is found
    }
}

## 2. Error Handling in PowerShell

### 2.1 `try-catch-finally` Blocks

- **Definition**: Used to handle exceptions (errors) in PowerShell scripts. The `try` block contains code that might throw an exception, `catch` is used to handle the error, and `finally` (optional) contains code that runs regardless of whether an error occurred.
- **Syntax**:
  ```powershell
  try {
      # Code that might throw an error
  } catch {
      # Code to handle the error
  } finally {
      # Code that runs after try/catch, regardless of outcome
  }
````

- **Example**:
  ```powershell
  try {
      $result = 1 / 0  # This will throw a divide by zero error
  } catch {
      Write-Host "An error occurred: $_"
  } finally {
      Write-Host "Execution completed."
  }
  ```

## 3. Practice Section

### 3.1 Practice 1: Identify Odd or Even Numbers

- **Task**: Prompt the user for input and check if it is an odd or even number. If the input is not a number, display an error message.
- **Example**:
  ```powershell
  $input = Read-Host -Prompt "Please enter a number"
  if (-not [int]::TryParse($input, [ref]0)) {
      Write-Host "The input '$input' is not a number. Please enter a valid number." -ForegroundColor Yellow -BackgroundColor Black
  } else {
      if ($input % 2 -eq 0) {
          Write-Host "$input is an even number."
      } else {
          Write-Host "$input is an odd number."
      }
  }
  ```

### 3.2 Practice 2: Days of the Week with `switch`

- **Task**: Prompt the user for a day of the week and output a message depending on the day.
- **Example**:
  ```powershell
  $day = Read-Host -Prompt "Enter a day of the week"
  switch ($day) {
      "Monday" { Write-Host "Start of the work week." }
      "Friday" { Write-Host "Almost weekend!" }
      "Saturday" { Write-Host "It's the weekend!" }
      "Sunday" { Write-Host "It's the weekend!" }
      Default { Write-Host "Just another day." }
  }
  ```

### 3.3 Practice 3: Repeated Input with `do-while`

- **Task**: Find Sales department employees, and all low paid employees, with single loop.
- **Example**:

  ```powershell
  $all_Employees = Invoke-RestMethod -Uri "https://psdemo.adminfamily.com/api/v1/employees"

  $list_LowPaid = @()
  $list_SalesDepartment = @()
  foreach($employee in $all_Employees){
      if ($employee.Salary -lt 130000){
          $list_LowPaid += $employee
      }
      if ($employee.Department -eq 'Sales'){
          $list_SalesDepartment += $employee
      }
  }
  ```

### 3.4 Practice 4: Error Handling with `try-catch`

- **Task**: Write a script that divides two numbers provided by the user and handles any errors that might occur (e.g., division by zero).
- **Example**:
  ```powershell
  try {
      $numerator = [int](Read-Host -Prompt "Enter the numerator")
      $denominator = [int](Read-Host -Prompt "Enter the denominator")
      if ($denominator -eq 0) {
          throw "Division by zero is not allowed."
      }
      $result = $numerator / $denominator
      Write-Host "The result is: $result"
  } catch {
      Write-Host "An error occurred: $_"
  } finally {
      Write-Host "Thank you for using the division script."
  }
  ```

### 3.5 Practice 5: Using API for Employee Management

- **Task**: Write a script that interacts with the Employee API to increase the salary of all employees earning less than $130,000 by 50%.
- **Example**:

  ```powershell
  $all_Employees = Invoke-RestMethod -Uri "https://psdemo.adminfamily.com/api/v1/employees"
  $low_Paid_Employees = $all_Employees | Where-Object { $_.Salary -lt 130000 }
  foreach ($employee in $low_Paid_Employees) {
      $newSalary = [int]$employee.Salary + [int]($employee.Salary * 0.5)
      Write-Host "Increasing $($employee.Name)'s salary from $($employee.Salary) to $($newSalary)" -ForegroundColor Cyan -BackgroundColor Black

      $body = @{
          Salary = $newSalary
      }
      $jsonBody = $body | ConvertTo-Json
      $thisAPI_Call_Results = Invoke-RestMethod -Uri "https://psdemo.adminfamily.com/api/v1/employees/$($employee.ID)" -Method Put `
          -Body $jsonBody -ContentType "Application/Json"
  }
  ```

## 4. Conclusion

- **Recap**:

  - Discussed `switch` statements, `do-while` loops, and error handling in PowerShell.
  - Completed hands-on exercises to reinforce learning.

- **Q&A**:

  - Any Questions!? :)

- **Homework**:
  - Practice writing more scripts that utilize these concepts to solidify your understanding. use systems or services under your control to practice these concepts in real world.
