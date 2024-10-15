# Session 10: Final Lecture - Git, Recap, and Exam

---

## Part 1: Introduction to Git

### 1.1 Installing Git on Windows
- **Step 1**: Download Git from [Git for Windows](https://git-scm.com/download/win).
- **Step 2**: Run the installation wizard.
  - Select options like Git Bash, editor, etc.
- **Step 3**: Verify installation:
  ```bash
  git --version
  ```

### 1.2 Basic Git Commands
- **git init**: Initializes a local Git repository.
  ```bash
  git init
  ```
- **git clone**: Clones an existing repository.
  ```bash
  git clone https://github.com/user/repo.git
  ```
- **git add**: Stages files for commit.
  ```bash
  git add <filename>
  ```
- **git commit**: Commits staged changes.
  ```bash
  git commit -m "commit message"
  ```
- **git push**: Pushes changes to the remote repository.
  ```bash
  git push origin main
  ```
- **git pull**: Pulls the latest changes from the remote repository.
  ```bash
  git pull origin main
  ```
- **git status**: Displays the state of your working directory and staging area.
  ```bash
  git status
  ```
- **git log**: Shows the commit history.
  ```bash
  git log
  ```

---

## Part 2: Recap of Previous Sessions
 Lets have an overview on the session 1-9
### **Session 1: PowerShell Fundamentals**

- **Key Topics:**
  - Introduction to PowerShell and comparison with other scripting languages.
  - Installation and configuration of PowerShell.
  - Key cmdlets and the help system (`Get-Help`, `Update-Help`).

---

### **Session 2: Data Types and Variables**

- **Key Topics:**
  - PowerShell data types: strings, integers, arrays, hashtables.
  - Declaring and using variables.
  - Simple scripts and object output (`Get-Process | Format-Table`).

---

### **Session 3: Cmdlets, Pipelining, and Data Manipulation**

- **Key Topics:**
  - Working with common cmdlets (`Get-Process`, `Get-Service`, `Stop-Service`).
  - The PowerShell pipeline and using `$_` automatic variable.
  - Selecting properties with `Select-Object`, invoking methods on objects.

---

### **Session 4: File Operations and Control Flow**

- **Key Topics:**
  - File system cmdlets (`Get-Item`, `Get-ChildItem`, `Copy-Item`, `Move-Item`).
  - Registry access using PowerShell providers.
  - Control flow statements (`if`, `for`, `while`, `switch`).

---

### **Session 5: Advanced Flow Control and Error Handling**

- **Key Topics:**
  - Advanced flow control: `switch`, `do-while`, `break`, `continue`.
  - Error handling with `try-catch-finally`.
  - Practical applications for handling loops and conditions.

---

### **Session 6: PowerShell Functions and Modules**

- **Key Topics:**
  - Creating and using functions.
  - Function parameters, including validation and parameter sets.
  - Introduction to PowerShell modules (`Import-Module`, `Export-ModuleMember`).

---

### **Session 7: Writing Help for Functions and Modules**

- **Key Topics:**
  - Writing comment-based help for PowerShell functions.
  - Creating script modules (`.psm1`), module manifests (`.psd1`).
  - Exporting functions with `Export-ModuleMember` for reuse.

---

### **Session 8: Web Development with PowerShell and Pode**

- **Key Topics:**
  - Web development basics: routes, requests, responses.
  - Using the Pode framework for web applications.
  - Handling query strings, request bodies, and route parameters.
  - Rendering views with Bootstrap for styling.

---

### **Session 9: PowerShell Remoting, Jobs, and Concurrency**

- **Key Topics:**
  - PowerShell remoting (`Invoke-Command`, `New-PSSession`).
  - Running background jobs (`Start-Job`, `Receive-Job`).
  - Asynchronous processing with `ForEach-Object -Parallel`.
  - Useful system cmdlets (`Get-NetTCPConnection`, `Get-Process`).

---
## Bonus: NSSM for Microsoft Windows
You can use `NSSM` tool to convert your PowerShell Scripts into Windows Services.

# Final Exam (10 Questions)

### 1. What does the following Git command do?
   ```bash
   git clone https://github.com/user/repo.git
   ```
   - a) Clones a local repository.
   - b) Clones a remote repository to your local machine.
   - c) Commits changes to the repository.
   - d) Pulls the latest changes from the remote repository.
   **Answer**: b) Clones a remote repository to your local machine.

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

### 3. Which of the following is a correct way to define a custom object in PowerShell?
   - a) `@{name="value"}`
   - b) `[pscustomobject] @{name="value"}`
   - c) `[customobject] @{name="value"}`
   - d) `[object] @{name="value"}`

### 4. Which cmdlet would you use to retrieve data from a REST API in PowerShell?
   - a) `Invoke-Expression`
   - b) `Invoke-RestMethod`
   - c) `Invoke-WebRequest`
   - d) `Invoke-Command`

### 5. What type of data structure is used to store key-value pairs in PowerShell?
   - a) Array
   - b) Hashtable
   - c) List
   - d) Dictionary

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


### 7. Which of the following parameters can be used to validate a parameter value in a PowerShell function?
   - a) `[ValidateScript()]`
   - b) `[ValidatePattern()]`
   - c) `[ValidateRange()]`
   - d) All of the above

### 8. What is the difference between `ForEach` and `ForEach-Object` in PowerShell?
   - a) They are identical.
   - b) `ForEach` is a cmdlet, and `ForEach-Object` is a loop.
   - c) `ForEach` is a loop used in scripts, and `ForEach-Object` is Cmdlet used in the pipeline.
   - d) `ForEach` is for parallel execution.

### 9. How can you pass variables into a remote session with `Invoke-Command`?
   - a) `-ArgumentList` and `$Using:var`
   - b) `$var`
   - c) `param($var)`
   - d) `$global:var`

### 10. Which of the following cmdlets retrieves system information, including network adapters and TCP connections?
   - a) `Get-NetTCPConnection`
   - b) `Get-Process`
   - c) `Get-Service`
   - d) `Test-NetConnection`

---

### **Answer Key**:
1. b)  
2. c)  
3. b)  
4. b)  
5. b)  
6. c)  
7. d)  
8. c)  
9. a)  
10. a)
