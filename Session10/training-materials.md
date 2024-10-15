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

### 2.1 Session 1 - PowerShell Basics
- **What is PowerShell?**
  - A task automation framework built on .NET.
- **PowerShell Benefits for IT Pros**:
  - Automation, error reduction, integration.
- **Cmdlet Syntax**:
  - Verb-Noun structure (`Get-Process`, `Stop-Service`).
- **Help System**:
  - `Get-Help`, `Get-Help -Examples`.

### 2.2 Session 2 - PowerShell Data Types
- **Data Types**:
  - **String**, **Integer**, **Boolean**, **Array**, **Hashtable**.
- **Cmdlet Anatomy**:
  - Cmdlets follow a Verb-Noun structure.
- **Common Methods**:
  - `.ToUpper()`, `.ToLower()`, `.Split()`.
- **Creating Custom Objects**:
  - `[pscustomobject]@{name="value"}`.

### 2.3 Session 3 - Cmdlets, Pipelining, File Operations
- **File Operations**:
  - Working with **CSV**, **JSON**, **XML**.
  - `Import-Csv`, `Export-Csv`.
- **Pipelining**:
  - Pass output of one command to another.
- **Filtering**:
  - `Where-Object`, `Select-Object`, `Sort-Object`.

### 2.4 Session 4 - Control Flow and Scripting
- **If/Else, Switch-Case**:
  - Conditional logic for decision making.
  - Example Switch-Case:
    ```powershell
    $value = 2
    switch ($value) {
      1 { "Value is 1" }
      2 { "Value is 2" }
      default { "Value is unknown" }
    }
    ```
- **Loops**:
  - `For`, `While`, `ForEach`.

### 2.5 Session 5 - PowerShell Functions
- **Function Definition**:
  - Modularize your scripts.
- **Parameter Validation**:
  - Use `[ValidateNotNullOrEmpty()]`, `[ValidateRange()]`.
- **Switch Parameters**:
  - Boolean flags using `[switch]`.

### 2.6 Session 6 - PowerShell Modules and .NET Assemblies
- **PowerShell Modules**:
  - Modularize and export cmdlets using `Export-ModuleMember`.
- **Working with .NET DLLs**:
  - Import external .NET libraries and create functions that wrap DLL methods.

### 2.7 Session 7 - PowerShell Remoting and Jobs
- **Remoting**:
  - Using `Invoke-Command`, `New-PSSession` for remote execution.
- **PowerShell Jobs**:
  - Asynchronous processing using `Start-Job` and `Receive-Job`.

### 2.8 Session 8 - PowerShell Web Development with Pode
- **Pode Web Development**:
  - Create simple APIs, serve static files, handle HTTP requests.
- **Request Parameters**:
  - Using `$WebEvent.Data`, `$WebEvent.Query`, and route parameters.

### 2.9 Session 9 - Concurrency, Jobs, and Runspaces
- **Concurrency**:
  - `ForEach-Object -Parallel` for parallel execution.
- **Runspaces**:
  - Advanced threading with PowerShell runspaces.

---

## Part 3: Final Exam (10 Questions)

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
   **Answer**: c) "Five"

### 3. Which of the following is a correct way to define a custom object in PowerShell?
   - a) `@{name="value"}`
   - b) `[pscustomobject] @{name="value"}`
   - c) `[customobject] @{name="value"}`
   - d) `[object] @{name="value"}`
   **Answer**: b) `[pscustomobject] @{name="value"}`

### 4. Which cmdlet would you use to retrieve data from a REST API in PowerShell?
   - a) `Invoke-Expression`
   - b) `Invoke-RestMethod`
   - c) `Invoke-WebRequest`
   - d) `Invoke-Command`
   **Answer**: b) `Invoke-RestMethod`

### 5. What type of data structure is used to store key-value pairs in PowerShell?
   - a) Array
   - b) Hashtable
   - c) List
   - d) Dictionary
   **Answer**: b) Hashtable

### 6. In PowerShell, how can you run code in parallel using PowerShell 7 or later?
   - a) `Start-Job`
   - b) `Invoke-Command -AsJob`
   - c) `ForEach-Object -Parallel`
   - d) `Start-Sleep`
   **Answer**: c) `ForEach-Object -Parallel`

### 7. Which of the following parameters can be used to validate a parameter value in a PowerShell function?
   - a) `[ValidateScript()]`
   - b) `[ValidatePattern()]`
   - c) `[ValidateRange()]`
   - d) All of the above
   **Answer**: d) All of the above

### 8. What is the difference between `ForEach` and `ForEach-Object` in PowerShell?
   - a) They are identical.
   - b) `ForEach` is a cmdlet, and `ForEach-Object` is a loop.
   - c) `ForEach` is used in scripts, and `ForEach-Object` is used in the pipeline.
   - d) `ForEach` is for parallel execution.
   **Answer**: c) `ForEach` is used in scripts, and `ForEach-Object` is used in the pipeline.

### 9. How can you pass variables into a remote session with `Invoke-Command`?
   - a) `$Using:var`
   - b) `$var`
   - c) `param($var)`
   - d) `$ArgumentList`
   **Answer**: a) `$Using:var`

### 10. Which of the following cmdlets retrieves system information, including network adapters and TCP connections?
   - a) `Get-NetTCPConnection`
   - b) `Get-Process`
   - c) `Get-Service`
   - d) `Test-NetConnection`
   **Answer**: a) `Get-NetTCPConnection`

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
