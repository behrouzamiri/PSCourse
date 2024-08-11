 # Run these LINE by LINE! and figure out what's the point
$String = "PowerShell Rocks! Let's dive in."

$String.Length
$String.StartsWith("P")
$String.StartsWith("p")
$String.ToLower()
$String.ToUpper()
$String.ToLower().StartsWith("p")
$String.Contains("werSh")
# Replace method, in String.Replcae(A,B), replaces A with B.
$String.Replace("Rocks", "is awesome")
$String.Replace("PowerShell", $env:USERNAME)
$String.Replace("PowerShell", $env:USERNAME).Replace("Let's dive in", "and is lovely")
$newString = $String.Replace("PowerShell", "Programing")
$newString
$String

# Substring
$String.Substring(1,3)
$String.Substring(0,5)
$String.Substring(11)   # if we don't specify the second argument (lenght), the total lenght (till the end of the string) will be used.
$String.Substring(11,6)
$String.Substring(11,6).Replace("R","Sh")

################################################################
$myArray = @("Behrouz", 25, $env:USERNAME, $env:COMPUTERNAME, "some text", "more text")

$myArray[0]
$myArray[1]
$myArray[1..3]
"My username is not " + $myArray[0]
"My UserName is " + $env:USERNAME
"My UserName is $($env:USERNAME)"

$myArray.IndexOf("some text")
$myArray[4]
$myArray[($myArray.IndexOf("some text"))] #  ($myArray.IndexOf("some text")) = 4 => $myArray[4] => some text
$myArray[($myArray.IndexOf("some text") - 1)] # ($myArray.IndexOf("some text")) = 4 => (4 - 1) => $myArray[3] => $env:COMPUTERNAME
$myArray.IndexOf("something not in array") # when something is not in an array, it returns -1

$myArray = $myArray + "ozve jadid dar arayeh!"
$myArray[6] # the new member is added into the array, in the end of it.

$newArray = $myArray
$myArray[4]
$newArray[4]

$myArray[4] = "something else!"
$myArray[4]
$newArray[4] # Arrays are referencing to the data! that's why when we change something in the old array, it also updates in the new array.

$newArray = $myArray.Clone()
$myArray[4]
$newArray[4]
$myArray[4] = $myArray[4].Replace("else","Other!")
$myArray[4]
$newArray[4]
#####################################################################
$MyHashTable = @{
    UserName = $env:USERNAME
    ComputerName = $env:COMPUTERNAME
}

$MyHashTable
$MyHashTable.Add("ProfilePath",$env:HOMEPATH)
$MyHashTable
$MyHashTable.Add("SystemArchitecture",$env:PROCESSOR_ARCHITECTURE)
$MyHashTable
$MyHashTable.Remove("SystemArchitecture")
$MyHashTable
$MyHashTable["UserName"] = " --- no user name --- "
$MyHashTable
$MyHashTable.Keys
$MyHashTable.Values
 
