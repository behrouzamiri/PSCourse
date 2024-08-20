# Question1:
# List all files larger than 100MB in a specific directory on your system. Display their size, name, and last modification date.

## Answer:

# Specify the directory path
$directoryPath = "C:\my\example\masir"

# Use Get-ChildItem to list files, filter by size, and select the required properties
Get-ChildItem -Path $directoryPath -File -Recurse | `
Where-Object { $_.Length -gt 100MB } | `
Select-Object Name, Length, LastWriteTime

### Explanation:
### Get-ChildItem lists all files in the specified directory and its subdirectories (-Recurse).
### Where-Object filters the files to include only those larger than 100MB.
### Select-Object selects and displays the file name, size (Length), and last modification date (LastWriteTime).

# Question2 :
# Write a script that converts a CSV file to JSON format. The user should provide the CSV file path using Read-Host, and the output should be saved as a JSON file in the same location with the same name.

## Answer:

# Ask the user for the path to the CSV file
$csvFilePath = Read-Host "Please enter the full path to the CSV file"

# Read the CSV file
$csvContent = Import-Csv -Path $csvFilePath

# Convert the CSV content to JSON
$jsonContent = $csvContent | ConvertTo-Json

# Determine the output file path by changing the file extension to .json
$jsonFilePath = $csvFilePath.replace(".csv", ".json")

# Save the JSON content to a file
$jsonContent | Set-Content -Path $jsonFilePath

Write-Output "CSV file converted to JSON and saved as $jsonFilePath"

### Explanation:

### Read-Host prompts the user to input the path to the CSV file.
### Import-Csv reads the content of the CSV file into a PowerShell object.
### ConvertTo-Json converts the CSV content into JSON format.
### .replace(".csv", ".json") changes the file extension from .csv to .json to determine the output file path.
### Set-Content writes the JSON content to the new file.
### Write-Output informs the user where the JSON file has been saved.