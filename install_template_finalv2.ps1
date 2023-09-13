# If we are running as a 32-bit process on an x64 system, re-launch as a 64-bit process
if ("$env:PROCESSOR_ARCHITEW6432" -ne "ARM64") {
    if (Test-Path "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe") {
        & "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy bypass -File "$PSCommandPath"
        Exit $lastexitcode
    }
}

## Insert msi files name here

$MSIName = "<filename>"


## Sets variables for log files

$MSIbase = (Get-Item $MSIName).BaseName
$Date = get-date -Format yyyyMMddTHHmmss
$log= "$env:TEMP\$MSIbase$Date.log"


##Setting args for when calling msiexec.exe
## "/L*v" $logFile sets the arg for verbose logging. Remove if desired.
## Log file will be stored at C:\Users\WDAGUtilityAccount\AppData\Local\Temp

$Args = @('/i'
          "$MSIName"
          '/qn'
          '/L*v'
          "$log")



## If there is a file that needs copied as part of the install, use the section below.
## The file will need to be included as part of the .intunewin file.


    ## Sets the variables for the file and the destination

    $CopyFile = "<filename>"
    $DestinationFolder = "<absolutefilepath>"

    ## Creates new directory if it doesn't exist and copies the file to the destination

    if (!(Test-Path -path $destinationFolder)) {New-Item $destinationFolder -Type Directory}

    Copy-Item $CopyFile -Destination $destinationFolder 


## Starts the process of installing an MSI application

Start-Process "msiexec.exe" -ArgumentList "$Args" -Wait -NoNewWindow