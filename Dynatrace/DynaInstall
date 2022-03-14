
<#
The Purpose of this script is to install the dynatrace agent to a target server. The env:server variable
is defined by the user when run the pipeline. This script grabs the latest file in the 'dynatrace' container
in the dcod storage account. It pulls it down, and runs the exe. Logs are sent to c:\logs\dynatrace
-StephenM
#>

param (
$DynaVersion
)


#begin connect to target server
Write-host " createdby '$env:Createdby' "
Write-host " Running on Server '$env:server' "
$DynaVersion =$env:DynaVersion
$servername =$env:server
$clientnumber =$env:customerid
$performance =$env:Perf
$DynaVersion = $env:DynaVersion
start-transcript c:\logs\dyna-transcriptlocal.txt

hostname 
whoami

invoke-command -ComputerName $env:server -ScriptBlock {

write-host "Deployment Dyna Version" $Using:DynaVersion
start-transcript c:\logs\dyna-transcript.txt

#setup logging
$logdir = 'c:\logs'
$scriptname = "InstallDynatrace.csv"
$logfilename = (get-date -Format "hhmmss") + $scriptname
function Write-Log {
  [CmdletBinding()]
  param(
      [Parameter()]
      [ValidateNotNullOrEmpty()]
      [string]$Message,

      [Parameter()]
      [ValidateNotNullOrEmpty()]
      [ValidateSet('INFORMATION', 'WARNING', 'ERROR')]
      [string]$Severity = 'INFORMATION'
  )
  mkdir c:\logs -ErrorAction SilentlyContinue # Create logs directory
  [pscustomobject]@{
      Date = (Get-Date -format "MM-dd-yyyy")
      Time = (Get-Date -format "HH:mm")
      Severity = $Severity
      Message  = $Message
  } | Export-Csv -Path "$logDir\$(Get-Date -Format MM-dd-yyyy)-$($logFileName).txt" -Append -NoTypeInformation
}
write-log -Severity INFORMATION -Message  "Connected to server"

###Change these lines to set a new installer
###When changing the BlobURI, you will need to manually add a "?" at the end of what Azure gives you. 

switch -Wildcard ($Using:servername) {
  "*POC*"     { $BlobUri = 'https://vmprovisioning.blob.core.windows.net/dynatrace/Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_POC.exe?' ; $filedownload = 'C:\Temp\Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_POC.exe' }
  "*DEV*"     { $BlobUri = 'https://vmprovisioning.blob.core.windows.net/dynatrace/Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_DEV.exe?' ; $filedownload = 'C:\Temp\Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_DEV.exe' }
  "*UAT*"     { $BlobUri = 'https://vmprovisioning.blob.core.windows.net/dynatrace/Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_UAT.exe?' ; $filedownload = 'C:\Temp\Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_UAT.exe' }
  "*PRD*"     { $BlobUri = 'https://vmprovisioning.blob.core.windows.net/dynatrace/Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_PRD.exe?' ; $filedownload = 'C:\Temp\Dynatrace-OneAgent-Windows-' + $Using:DynaVersion +'_PRD.exe' }
  Default { Write-Error "No environment Defined: $env:infraenvironment" ; throw 'Check work item for correct environment' }
}

$sas = '*****SAS TOKEN HERE****'


<# Download via URI using SAS #>
$FullUri = "$BlobUri$sas"
(New-Object System.Net.WebClient).DownloadFile($FullUri, $filedownload)


#save Filename, for directory and exe
$Dynainstallpath = get-childitem C:\temp -name -filter *Dynatrace-OneAgent-Windows-*
$OutputPath = 'C:\' + $Dynainstallpath

If(!(test-path $OutputPath))
{
      New-Item -ItemType Directory -Force -Path $OutputPath
      write-host -Severity INFORMATION -Message  "creating Output directory"

}

Copy-Item "C:\temp\$Dynainstallpath" -Destination $OutputPath



if ($Using:servername -like "*PRD*") {
$Arguments = '--set-host-group='+ $Using:clientnumber +'_PRD_CLSTR --set-app-log-content-access=true --set-watchdog-portrange=3000:3010 --set-infra-only=true --quiet'
write-log -Severity INFORMATION -Message  "Installing PRD CLuster'"
write-log -Severity INFORMATION -Message  " Arguments are $Arguments"
}
elseif ($Using:servername -like "*DEV*") {
$Arguments = '--set-host-group='+ $Using:clientnumber +'_DEV_CLSTR --set-app-log-content-access=true --set-watchdog-portrange=3000:3010 --set-infra-only=true --quiet'
write-log -Severity INFORMATION -Message  "Installing $Using:clientnumber DEV CLuster'"
write-log -Severity INFORMATION -Message  " Arguments are $Arguments"
}
elseif ($Using:servername -like "*POC*") {
$Arguments = '--set-host-group='+ $Using:clientnumber +'_POC_CLSTR --set-app-log-content-access=true --set-watchdog-portrange=3000:3010 --set-infra-only=true --quiet'
write-log -Severity INFORMATION -Message  "Installing POC CLuster'"
write-log -Severity INFORMATION -Message  " Arguments are $Arguments"
}
elseif ($Using:servername -like "*UAT*") {
$Arguments = '--set-host-group='+ $Using:clientnumber +'_UAT_CLSTR --set-app-log-content-access=true --set-watchdog-portrange=3000:3010 --set-infra-only=true --quiet'
write-log -Severity INFORMATION -Message  "Installing UAT CLuster'"
write-log -Severity INFORMATION -Message  " Arguments are $Arguments"
}

##Special case for performance boxes. this is set at runtime.
if($Using:performance -eq 'True'){
  $Arguments = '--set-host-group='+ $Using:clientnumber +'_PERF_CLSTR --set-app-log-content-access=true --set-watchdog-portrange=3000:3010 --set-infra-only=true --quiet'
write-log -Severity INFORMATION -Message  "Installing PERF CLuster'"
}else
{
  write-host 'This is not a performance cluster'
}

$install = $OutputPath + '\' +$Dynainstallpath

set-location $OutputPath
try{
start-process $install $Arguments -wait

write-log -Severity INFORMATION -Message  "Successfully installed dynatrace'"
}catch{
write-log -Severity INFORMATION -Message  "Dynatrace install has failed'"
write-log -Severity ERROR -Message "$_"
write-log -Severity INFORMATION -Message  "ARGUMENTS = $Arguments"
}
set-location C:\temp
start-sleep -seconds 60
Remove-Item -Path C:\temp\$Dynainstallpath -Force
Remove-Item -Path $OutputPath -Force -Recurse
stop-transcript
} #end Invoke-cmd

stop-transcript
