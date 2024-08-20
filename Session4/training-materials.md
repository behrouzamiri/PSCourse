# PowerShell Course - Day 4: PowerShell Providers, File Operations, and Control Flow Basics

---

## 1. Introduction
- **Welcome back**
- **Recap of the previous session**
- **Overview of today's topics**

---

## Module 5: PowerShell Providers and File Operations

PowerShell Providers allow you to access data stores, such as the file system or registry, in a consistent manner. In this section, we'll explore how to work with file systems, manage files and folders, and access the Windows registry.

### 1.1 Understanding PowerShell Providers

**Cmdlets:**
- **Get-PSProvider:** Lists the available providers in the current session.
  ```powershell
  Get-PSProvider
  ```

**Explanation:** PowerShell Providers abstract various data stores, allowing you to interact with them in a standardized way. Common providers include the file system, registry, and environment variables.

### 1.2 File System Management

The FileSystem provider is the most commonly used provider in PowerShell, enabling you to navigate and manipulate the file system.

**Cmdlets:**
- **Get-Item:** Retrieves an item (file, directory, registry key, etc.) at a specified location.
  ```powershell
  Get-Item -Path "C:\example.txt"
  ```
  - **-Path:** Specifies the path to the item.

- **Get-ChildItem:** Retrieves the items (files and directories) in a specified location.
  ```powershell
  Get-ChildItem -Path "C:\"
  ```
  - **-Path:** Specifies the path to the directory.
  - **-Recurse:** Retrieves items in the specified location and all subdirectories.
  - **-Filter:** Filters the items based on a specified condition.

**Explanation:** `Get-Item` is used to retrieve a specific item, while `Get-ChildItem` is used to list all items in a directory. These cmdlets allow you to navigate the file system and inspect files and folders.

### 1.3 Registry Access

The Registry provider allows you to access the Windows Registry just like the file system.

**Cmdlets:**
- **Get-Item:** Retrieves a registry key.
  ```powershell
  Get-Item -Path "HKLM:\Software\Microsoft"
  ```

- **Get-ChildItem:** Lists subkeys and values in a registry key.
  ```powershell
  Get-ChildItem -Path "HKLM:\Software\Microsoft"
  ```

**Explanation:** The Registry provider enables you to access and manipulate the Windows Registry, treating registry keys and values like directories and files.

### 1.4 Working with Files and Folders

PowerShell provides a wide range of cmdlets for managing files and folders, including creating, moving, copying, and deleting them.

**Cmdlets:**
- **New-Item:** Creates a new file or directory.
  ```powershell
  New-Item -Path "C:\example.txt" -ItemType File
  ```
  - **-ItemType:** Specifies the type of item to create (e.g., File, Directory).

- **Copy-Item:** Copies an item from one location to another.
  ```powershell
  Copy-Item -Path "C:\example.txt" -Destination "D:\backup\"
  ```
  - **-Path:** Specifies the item to copy.
  - **-Destination:** Specifies the destination path.

- **Move-Item:** Moves an item from one location to another.
  ```powershell
  Move-Item -Path "C:\example.txt" -Destination "D:\backup\"
  ```

- **Remove-Item:** Deletes an item.
  ```powershell
  Remove-Item -Path "C:\example.txt"
  ```

**Explanation:** These cmdlets allow you to perform common file and folder operations, such as creating, copying, moving, and deleting files and directories.

### 1.5 Practical File Operations

**Example 1: Creating and Managing a Directory Structure**
```powershell
# Create a new directory
New-Item -Path "C:\Projects" -ItemType Directory

# Create a subdirectory
New-Item -Path "C:\Projects\PowerShell" -ItemType Directory

# Create a new file in the subdirectory
New-Item -Path "C:\Projects\PowerShell\script.ps1" -ItemType File

# Copy the file to another location
Copy-Item -Path "C:\Projects\PowerShell\script.ps1" -Destination "C:\Backup\script.ps1"

# Remove the original file
Remove-Item -Path "C:\Projects\PowerShell\script.ps1"
```

**Example 2: Navigating and Modifying the Registry**
```powershell
# Retrieve a registry key
Get-Item -Path "HKCU:\Software\MyApp"

# List subkeys in the registry
Get-ChildItem -Path "HKCU:\Software\MyApp"

# Create a new registry key
New-Item -Path "HKCU:\Software\MyApp\Settings" -ItemType Directory

# Remove a registry key
Remove-Item -Path "HKCU:\Software\MyApp\Settings"
```

---

## Module 4: Control Flow and Scripting Basics

Control flow is essential for creating scripts that can make decisions and repeat actions. This module covers conditional statements, loops, and scripting best practices.

### 2.1 Conditional Statements (If, Else)

**Cmdlets and Keywords:**
- **If, ElseIf, Else:** Used to execute code based on conditional logic.
  ```powershell
  $value = 10

  if ($value -gt 5) {
      Write-Output "Value is greater than 5"
  }
  elseif ($value -eq 5) {
      Write-Output "Value equals 5"
  }
  else {
      Write-Output "Value is less than 5"
  }
  ```

**Explanation:** Conditional statements (`If`, `ElseIf`, `Else`) allow your script to perform different actions based on different conditions.

### 2.2 Loops (For, While)

Loops enable you to repeat actions multiple times based on conditions.

**Cmdlets and Keywords:**
- **For:** Repeats a block of code a specific number of times.
  ```powershell
  for ($i = 0; $i -lt 5; $i++) {
      Write-Output "Iteration $i"
  }
  ```

- **While:** Repeats a block of code as long as a condition is true.
  ```powershell
  $counter = 0

  while ($counter -lt 5) {
      Write-Output "Counter is $counter"
      $counter++
  }
  ```

**Explanation:** The `For` loop is used when you know how many times you need to repeat an action. The `While` loop continues to execute as long as the specified condition remains true.

---

## 3. Summary and Q&A
- **Recap of today's topics**
- **Questions and discussion**

---
