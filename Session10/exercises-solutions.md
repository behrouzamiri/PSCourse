### 1. What does the following Git command do?
   ```bash
   git clone https://github.com/user/repo.git
   ```
   - a) Clones a local repository.
   - b) Clones a remote repository to your local machine.
   - c) Commits changes to the repository.
   - d) Pulls the latest changes from the remote repository.
   **Answer**: b) Clones a remote repository to your local machine.

---

### 2. What is the result of the following Switch-Case block in PowerShell?
   ```powershell
   $number = 5
   switch ($number) {
     1 { "One" }
     2 { "Two" }
     5 { "Five" }
     default { "Unknown" }
   }
   ```
   - a) "One"
   - b) "Unknown"
   - c) "Five"
   - d) "Two"
   **Answer**: c) "Five"

---

### 3. Which of the following is a correct way to define a custom object in PowerShell?
   - a) `@{name="value"}`
   - b) `[pscustomobject] @{name="value"}`
   - c) `[customobject] @{name="value"}`
   - d) `[object] @{name="value"}`
   **Answer**: b) `[pscustomobject] @{name="value"}`

---

### 4. Which cmdlet would you use to retrieve data from a REST API in PowerShell?
   - a) `Invoke-Expression`
   - b) `Invoke-RestMethod`
   - c) `Invoke-WebRequest`
   - d) `Invoke-Command`
   **Answer**: b) `Invoke-RestMethod`

---

### 5. What type of data structure is used to store key-value pairs in PowerShell?
   - a) Array
   - b) Hashtable
   - c) List
   - d) Dictionary
   **Answer**: b) Hashtable

---

### 6. What is the output of the following PowerShell script?

```powershell
$counter = 0
while ($true) {
    $counter++
    
    if ($counter -lt 3) {
        Write-Host "Skipping iteration $counter"
        continue
    }
    
    if ($counter -eq 5) {
        Write-Host "Breaking the loop at iteration $counter"
        break
    }
    
    Write-Host "Processing iteration $counter"
}
```
   - a) The loop will print "Skipping iteration" for 1, 2 and break immediately after.
   - b) The loop will run infinitely, printing "Processing iteration" repeatedly.
   - c) The loop will skip the first two iterations, print "Processing iteration" for 3, 4, and break at 5.
   - d) The loop will run without skipping any iteration.
   **Answer**: c) The loop will skip the first two iterations, print "Processing iteration" for 3, 4, and break at 5.

---

### 7. Which of the following parameters can be used to validate a parameter value in a PowerShell function?
   - a) `[ValidateScript()]`
   - b) `[ValidatePattern()]`
   - c) `[ValidateRange()]`
   - d) All of the above
   **Answer**: d) All of the above

---

### 8. What is the difference between `ForEach` and `ForEach-Object` in PowerShell?
   - a) They are identical.
   - b) `ForEach` is a cmdlet, and `ForEach-Object` is a loop.
   - c) `ForEach` is a loop used in scripts, and `ForEach-Object` is Cmdlet used in the pipeline.
   - d) `ForEach` is for parallel execution.
   **Answer**: c) `ForEach` is a loop used in scripts, and `ForEach-Object` is Cmdlet used in the pipeline.

---

### 9. How can you pass variables into a remote session with `Invoke-Command`?
   - a) `-ArgumentList` and `$Using:var`
   - b) `$var`
   - c) `param($var)`
   - d) `$global:var`
   **Answer**: a) `-ArgumentList` and `$Using:var`

---

### 10. Which of the following cmdlets retrieves system information, including network adapters and TCP connections?
   - a) `Get-NetTCPConnection`
   - b) `Get-Process`
   - c) `Get-Service`
   - d) `Test-NetConnection`
   **Answer**: a) `Get-NetTCPConnection`

---