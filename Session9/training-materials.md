# Session 9: PowerShell Remoting, Jobs, Asynchronous Processing, and Concurrency

## 1. Introduction to PowerShell Remoting

### 1.1 What is PowerShell Remoting?
PowerShell Remoting allows you to run commands on one or more remote machines. It enables you to perform administrative tasks across multiple systems efficiently.

### 1.2 Enabling PowerShell Remoting
To start using remoting, you need to enable it on the systems where you want to run remote commands:

```powershell
Enable-PSRemoting -Force
```

This command configures the machine to receive remote commands.

### 1.3 Using `Invoke-Command` for Remote Execution

#### 1.3.1 Single Remote System

The `Invoke-Command` cmdlet runs commands on remote systems. Here’s an example of running a command on a single machine:

```powershell
Invoke-Command -ComputerName 'RemotePC' -ScriptBlock { Get-Process }
```

#### 1.3.2 Multiple Remote Systems

To run commands on multiple machines simultaneously:

```powershell
Invoke-Command -ComputerName 'Server1', 'Server2' -ScriptBlock { Get-Service }
```

#### 1.3.3 Passing Variables and Objects in Remoting

Use the `$Using:` scope modifier to pass variables from the local session to the remote session:

```powershell
$var = "Hello World"
Invoke-Command -ComputerName 'Server1' -ScriptBlock { Write-Output $Using:var }
```

You can also pass arguments with `$args`:

```powershell
Invoke-Command -ComputerName 'Server1' -ArgumentList "value1", "value2" -ScriptBlock {
    param($first, $second)
    Write-Host "First: $first, Second: $second"
}
```

### 1.4 Using Remote Sessions

Remote sessions allow you to create persistent connections. Here’s how to create a new session:

```powershell
$session = New-PSSession -ComputerName 'RemotePC'
Invoke-Command -Session $session -ScriptBlock { Get-Date }
Remove-PSSession -Session $session
```

You can also enter a remote session interactively:

```powershell
Enter-PSSession -ComputerName 'RemotePC'
```

### 1.5 Authentication and Security in Remoting

PowerShell Remoting uses various authentication mechanisms to ensure security.

#### 1.5.1 Trusted Hosts
You can configure a machine to accept remote commands only from trusted hosts:

```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'Server1,Server2'
```

#### 1.5.2 CredSSP, Kerberos, and Basic Authentication
CredSSP allows delegating credentials to remote machines for second-hop scenarios. Ensure Kerberos or basic authentication is properly set up if needed.

---

## 2. PowerShell over SSH Remoting

With PowerShell Core (7+), you can use SSH to establish remote sessions on Linux, macOS, or even Windows.

### 2.1 Enabling SSH-based Remoting
First, ensure SSH is installed and running. For Linux/macOS:

```bash
sudo apt install openssh-server
sudo service ssh start
```

For Windows, enable the OpenSSH server feature. Then connect using PowerShell:

```powershell
$session = New-PSSession -HostName 'remote-linux' -UserName 'admin'
Invoke-Command -Session $session -ScriptBlock { Get-Date }
```

### 2.2 Managing SSH Sessions
You can manage SSH sessions the same way as WSMan sessions, using `New-PSSession`, `Invoke-Command`, and `Remove-PSSession`.

---

## 3. PowerShell Jobs

### 3.1 Introduction to Jobs
Jobs allow you to run tasks asynchronously in the background, making it easy to handle long-running tasks without blocking the session.

### 3.2 Working with Background Jobs

#### 3.2.1 Starting Jobs with `Start-Job`

```powershell
Start-Job -ScriptBlock { Get-Process }
```

#### 3.2.2 Checking Job Status

```powershell
Get-Job
```

#### 3.2.3 Retrieving Job Results

```powershell
Receive-Job -Id 1
```

#### 3.2.4 Stopping Jobs

```powershell
Stop-Job -Id 1
```

### 3.3 Job Types

#### 3.3.1 Background Jobs
Basic jobs run in the background on the local system.

#### 3.3.2 WMI Jobs
Used for retrieving WMI data asynchronously:

```powershell
Get-WmiObject -Class Win32_Process -AsJob
```

#### 3.3.3 Scheduled Jobs
Scheduled jobs run on a set schedule:

```powershell
Register-ScheduledJob -Name "DailyCleanup" -ScriptBlock { Remove-Item "C:\Temp\*" }
```

Example: Create a scheduled job with triggers and custom options:

```PowerShell
$O = New-ScheduledJobOption -WakeToRun -StartIfIdle -MultipleInstancePolicy Queue
$T = New-JobTrigger -Weekly -At "9:00 PM" -DaysOfWeek Monday -WeeksInterval 2
$path = "\\Srv01\Scripts\UpdateVersion.ps1"
Register-ScheduledJob -Name "UpdateVersion" -FilePath $path -ScheduledJobOption $O -Trigger $T
```

---

## 4. Asynchronous Processing in PowerShell

### 4.1 The `Start-Job` Cmdlet for Asynchronous Execution

```powershell
Start-Job -ScriptBlock { Get-Service }
```

### 4.2 Using `Invoke-Command` with `-AsJob` for Remote Asynchronous Tasks

```powershell
Invoke-Command -ComputerName 'RemotePC' -ScriptBlock { Get-EventLog System } -AsJob
```

### 4.3 Asynchronous Task Management

#### 4.3.1 Waiting for Jobs to Finish

```powershell
$job = Start-Job -ScriptBlock {Start-Sleep -Seconds 15;get-date}
Wait-Job -Job $job 
```

#### 4.3.2 Removing Jobs

```powershell
Remove-Job -Id 2
```

---

## 5. Concurrency in PowerShell

### 5.1 Understanding Concurrency
Concurrency allows you to run multiple tasks in parallel, increasing performance for long-running or repetitive tasks.

### 5.2 Using `ForEach-Object -Parallel` (PowerShell 7+)

```powershell
$servers = @("Server1", "Server2", "Server3")
$servers | ForEach-Object -Parallel {
    Test-Connection -ComputerName $_
}
```

#### 5.2.1 Limitations and Best Practices
When using `ForEach-Object -Parallel`, it's important to handle scope properly. Also, be cautious with resource contention.

### 5.3 Concurrent Remoting with `Invoke-Command`

```powershell
Invoke-Command -ComputerName 'Server1', 'Server2' -ScriptBlock { Get-EventLog System } -ThrottleLimit 5
```

---

## 6. System Administration and Troubleshooting in PowerShell

PowerShell provides a set of cmdlets and tools for monitoring and troubleshooting system performance, network activity, and more.

### 6.1 Common System Cmdlets

#### 6.1.1 Network Visibility

```powershell
Get-NetTCPConnection
```
Displays the current TCP connections on the system.

#### 6.1.2 System Event Logs

```powershell
Get-EventLog -LogName System
```
Retrieves event logs from the system.

```powershell
Get-WinEvent -ComputerName $ThisServer -FilterHashtable @{LogName = 'AD FS/Admin'; ID = 407; StartTime = (Get-Date).AddHours(-1) } 
```

#### 6.1.3 Process Monitoring

```powershell
Get-Process
```
Displays a list of running processes.

#### 6.1.4 Other Useful Cmdlets for Admins

- **`Select-Object @{Name="<attributename>";Expression={<Powershell code>}}`**: selects what you specify!.
- **`Get-History`**: Displays the history of PowerShell commands.
- **`Get-Credential`**: Prompts the user for credentials.
- **`Import-CliXml` / `Export-CliXml`**: Imports or exports a PowerShell object to and from XML.
- **`Get-ComputerInfo`**: Retrieves detailed information about the computer system.
- **`Copy-Item`, `Move-Item`, `Rename-Item`**: Useful for file and folder management.
- **`Get-Random`**: Returns a random number or object.
- **`Get-Unique`**: Returns unique items from a collection.
- **`Set-Clipboard`**: Copies an object to the clipboard.
- **`Compare-Object`**: Compares two objects.
- **`Group-Object`**: Groups objects by a property.
- **`Out-GridView`**: Displays output in an interactive window.
- **`Start-Process -Credential`**: Starts a process with the provided credentials.
- **`Test-Path`**: Tests if a path exists.
- **`Get-NetIPAddress`**: Retrieves IP address configuration.
- **`Get-NetAdapter`**: Lists network adapters.
- **`Resolve-DnsName`**: Resolves a DNS name to an IP address.
- **`Import-PowerShellDataFile`**: Imports psd1 files.
- **`Get-DnsClientCache`**: View the DNS cache.

---

## Extra Reading: PowerShell Runspaces

### 7.1 Introduction to Runspaces
Runspaces offer a lower-level, more efficient way to handle concurrency in PowerShell. Unlike jobs, runspaces are more performant for heavy parallelization.

### 7.2 Creating and Managing Runspaces

#### 7.2.1 Creating a Single Runspace

```powershell
$runspace = [powershell]::Create().AddScript({ Get-Process }).BeginInvoke()
```

#### 7.2.2 Creating Multiple Runspaces for Parallel Processing

```powershell
$runspacePool = [runspacefactory]::CreateRunspacePool(1, 5)
$runspacePool.Open()
$runspaces = @()

foreach ($script in $scripts) {
    $runspace = [powershell]::Create().AddScript($script)
    $runspace.RunspacePool = $runspacePool
    $runspaces += [pscustomobject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke() }
}

$runspaces | ForEach-Object { $_.Pipe.EndInvoke($_.Status) }
```

---

## Conclusion

This session covered:
- PowerShell Remoting and SSH-based remoting.
- Background jobs for asynchronous task handling.
- Concurrency with `ForEach-Object -Parallel` and Runspaces.
- System administration and troubleshooting commands.
