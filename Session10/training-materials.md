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
Use the `exercises-questions.md` file, and answer the questions.

---

✨ **Wishing you continued success** ✨  
With ❤️,  
**Behrouz**
