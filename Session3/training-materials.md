# PowerShell Course - Day 3: Working with Cmdlets, Pipelining, and Data Manipulation

---

## 1. Introduction
- **Welcome back**
- **Recap of the previous session**
- **Overview of today's topics**

---

## 2. Running Cmdlets for Reading/Writing and Converting Files

PowerShell offers a variety of cmdlets to handle file operations, including reading, writing, and converting data in different formats such as CSV, TXT, XML, JSON, and CLIXML. Understanding these cmdlets and their parameters is crucial for effective data manipulation.

### 2.1 Working with CSV Files

**Cmdlets:**
- **Import-Csv:** Reads a CSV file and converts it into objects.
  ```powershell
  $data = Import-Csv -Path "data.csv"
  ```
  - **-Path:** Specifies the path to the CSV file.
  - **-Delimiter:** Specifies the delimiter used in the CSV file (default is a comma).
  - **-Header:** Specifies an alternative header row.
  
- **Export-Csv:** Converts objects into CSV format and writes them to a file.
  ```powershell
  $data | Export-Csv -Path "output.csv" -NoTypeInformation
  ```
  - **-Path:** Specifies the output path for the CSV file.
  - **-NoTypeInformation:** Omits the type information from the CSV output.
  - **-Delimiter:** Specifies the delimiter used in the output CSV file.

**Explanation:**
CSV (Comma-Separated Values) files are widely used for storing tabular data. PowerShell cmdlets `Import-Csv` and `Export-Csv` facilitate easy conversion between CSV files and PowerShell objects, allowing seamless data manipulation.

### 2.2 Working with TXT Files

**Cmdlets:**
- **Get-Content:** Reads the content of a text file.
  ```powershell
  $content = Get-Content -Path "file.txt"
  ```
  - **-Path:** Specifies the path to the text file.
  - **-Raw:** Reads the content of the file as a single string, rather than an array of lines.

- **Set-Content:** Writes content to a text file.
  ```powershell
  "This is a new line" | Set-Content -Path "file.txt"
  ```
  - **-Path:** Specifies the output path for the text file.
  - **-Encoding:** Specifies the encoding for the output file (e.g., UTF8, ASCII).

- **Add-Content:** Appends content to a text file.
  ```powershell
  "This is an appended line" | Add-Content -Path "file.txt"
  ```
  - **-Path:** Specifies the output path for the text file.
  - **-Encoding:** Specifies the encoding for the output file.

**Explanation:**
TXT files contain unformatted text. PowerShell provides cmdlets like `Get-Content`, `Set-Content`, and `Add-Content` to read, write, and append text data to files.

### 2.3 Working with XML Files

**Cmdlets:**
- **[xml] Type Accelerator:** Converts XML content into an XML object.
  ```powershell
  [xml]$xmlData = Get-Content -Path "data.xml"
  ```
  - **-Path:** Specifies the path to the XML file.

- **Save() Method:** Saves the XML object back to a file.
  ```powershell
  $xmlData.Save("output.xml")
  ```

**Explanation:**
XML (Extensible Markup Language) is used to store and transport structured data. By casting the content of an XML file to the `[xml]` type accelerator, PowerShell allows for easy manipulation of XML elements and attributes.

### 2.4 Working with JSON Files

**Cmdlets:**
- **ConvertFrom-Json:** Converts a JSON string into a PowerShell object.
  ```powershell
  $jsonData = Get-Content -Path "data.json" | ConvertFrom-Json
  ```
  - **-AsHashtable:** Converts the JSON to a hashtable instead of a custom object.

- **ConvertTo-Json:** Converts a PowerShell object into a JSON string.
  ```powershell
  $jsonData | ConvertTo-Json | Set-Content -Path "output.json"
  ```
  - **-Depth:** Specifies how deep the JSON serialization goes (default is 2).
  - **-Compress:** Produces a compact JSON format by removing white spaces.

**Explanation:**
JSON (JavaScript Object Notation) is a lightweight format for data interchange. PowerShell can easily convert between JSON strings and PowerShell objects using `ConvertFrom-Json` and `ConvertTo-Json`.

### 2.5 Working with CLIXML Files

**Cmdlets:**
- **Export-Clixml:** Exports a PowerShell object to a CLIXML file.
  ```powershell
  $data | Export-Clixml -Path "data.clixml"
  ```
  - **-Path:** Specifies the output path for the CLIXML file.

- **Import-Clixml:** Imports a CLIXML file into a PowerShell object.
  ```powershell
  $data = Import-Clixml -Path "data.clixml"
  ```

**Explanation:**
CLIXML (Command-Line Interface XML) is used by PowerShell to serialize objects, preserving their properties and methods. `Export-Clixml` and `Import-Clixml` cmdlets allow you to serialize and deserialize objects, making it possible to save and restore object states.

---

## 3. Introduction to Pipelining

Pipelining is a core feature in PowerShell that enables you to pass the output of one cmdlet directly into another cmdlet as input. This feature is essential for building efficient and concise commands.

### 3.1 How Pipelining Works

In PowerShell, the pipeline (`|`) passes objects from one cmdlet to the next. Unlike other shells that pass text, PowerShell passes objects, preserving the rich data structure throughout the pipeline. This allows each cmdlet in the pipeline to access properties and methods of the objects.

### 3.2 The `$_` Automatic Variable

Within the pipeline, PowerShell uses the `$_` automatic variable to represent the current object in the pipeline. This variable is often used in filtering and other operations that require referencing the current object.

### 3.3 Example: Listing and Sorting Processes
```powershell
Get-Process | Sort-Object -Property CPU
```
- **Explanation:** `Get-Process` retrieves a list of running processes, which is then sorted by CPU usage using `Sort-Object`.

### 3.4 Example: Filtering Files by Extension
```powershell
Get-ChildItem -Path "C:\Logs" | Where-Object { $_.Extension -eq ".log" }
```
- **Explanation:** `Get-ChildItem` lists all files in the specified directory, and `Where-Object` filters the files to include only those with a `.log` extension. The `$_` variable represents each file object in the pipeline.

---

## 4. Selecting Properties and Methods

PowerShell objects come with a variety of properties and methods. Cmdlets like `Select-Object` allow you to work with specific properties, and you can invoke methods directly on objects.

### 4.1 Selecting Properties

**Cmdlet:**
- **Select-Object:** Selects specific properties of an object.
  ```powershell
  Get-Process | Select-Object -Property Name, CPU
  ```
  - **-Property:** Specifies the properties to be selected.
  - **-ExpandProperty:** Expands a property to display its elements.

**Explanation:** `Select-Object` allows you to specify and work with selected properties of objects, providing a cleaner and more focused output.

### 4.2 Invoking Methods

**Example:**
```powershell
$service = Get-Service -Name "Spooler"
$service.Stop()
```
- **Explanation:** After retrieving the `Spooler` service object using `Get-Service`, the `Stop()` method is invoked to stop the service.

---

## 5. Filtering and Sorting Data

Filtering and sorting data are essential operations when working with large datasets. PowerShell provides powerful cmdlets like `Where-Object` and `Sort-Object` for these tasks.

### 5.1 Filtering Data

**Cmdlet:**
- **Where-Object:** Filters objects based on specified criteria.
  ```powershell
  Get-Process | Where-Object { $_.CPU -gt 100 }
  ```
  - **-FilterScript:** The script block used to define the filtering condition.

**Explanation:** `Where-Object` is used to filter objects that meet specific conditions. The `$_` variable is used to reference the current object in the pipeline.

### 5.2 Sorting Data

**Cmdlet:**
- **Sort-Object:** Sorts objects by specified property values.
  ```powershell
  Get-Process | Sort-Object -Property CPU -Descending
  ```
  - **-Property:** Specifies the property to sort by.
  - **-Descending:** Sorts the results in descending order.
  - **-Unique:** Returns only unique values from the sorted results.

**Explanation:** `Sort-Object` sorts objects based on property values, allowing you to organize your data for better analysis.

---

## 6. Summary and Q&A
- **Recap of today's topics**
- **Questions and discussion**

---

