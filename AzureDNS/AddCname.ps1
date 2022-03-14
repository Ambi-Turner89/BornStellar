<########################################################################################################################################################
    Name: Add-AZDNScname.Util.ps1
    Author: Randy Bordeaux 
    Date Created: 10/21/2021
    Date Modified:
    
    Description: 
        Add Azure DNS Zone cName Record
        Log file will be created in c:\logs
        
    Requirements: 
        
    Documentation: 
        https://docs.microsoft.com/en-us/powershell/azure/?view=azps-6.0.0
        https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-6.0.0
        https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1
        https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1
        https://www.powershellgallery.com/packages/Az/6.0.0
        https://github.com/Azure/azure-powershell/releases
        https://shell.azure.com

########################################################################################################################################################>
#STEVE comment out parameters if you want to created a dns record thru this script
<#param(
    [Parameter(Mandatory = $False)]
    [string]$dnsrecordname,
    [string]$dnsrecordurl
)#>
$error.clear()

<# Dynamic Variables #>
 $dnsrecordname = 'uncu314'  # for testing or if you want to run the script in PowerShell ISE 
 $dnsrecordurl = 'uncuat01dmz01elb01pip50.northcentralus.cloudapp.azure.com' # for testing or if you want to run the script in PowerShell ISE     
#only ELB has this

####################################### DO NOT CHANGE BELOW THIS LINE #######################################

<# Static Variables #>
$zonename = 'duckcreekondemand.com'
$rgname = 'unc-shr-01-dmz-01-rg'
$transcriptlog = "$logDir\$(Get-Date -Format MM-dd-yyyy)-$('Query-DNS' + '-Transcript').txt"

Start-Transcript -Path $transcriptlog
mkdir c:\logs -ErrorAction SilentlyContinue
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Message,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('INFORMATION', 'WARNING', 'ERROR')]
        [string]$Severity = 'INFORMATION'
    )
    <# Variables #>
    $logdir = 'C:\logs'
    $scriptname = '-AddAZDNScName'
    $logfilename = (Get-Date -Format 'hhmm') + $scriptname
    $logfullname = "$logDir\$(Get-Date -Format MM-dd-yyyy)-$($logFileName).txt"
    
    [pscustomobject]@{
        Date     = (Get-Date -Format 'MM-dd-yyyy')
        Time     = (Get-Date -Format 'HH:mm')
        Severity = $Severity
        Message  = $Message
    } | Export-Csv -Path $logfullname -Append -NoTypeInformation
} # End of function Write-Log 

<# Set Subscription #>
Set-AzContext -Subscription 'Duck Creek On Demand Shared'
Clear-Host 

<# Add DNS cName Record #>
Try {
      
    <# Create new DNS Entry #> 
    New-AzDnsRecordSet `
        -ZoneName duckcreekondemand.com -ResourceGroupName 'unc-shr-01-dmz-01-rg' -Name $dnsrecordname -RecordType 'CNAME' `
        -Ttl 600 -DnsRecords   (New-AzDnsRecordConfig -Cname $dnsrecordurl )  
    
}

Catch {
    Write-Log -Severity ERROR -Message "Error trying to add $dnsrecordname"
    Write-Log -Severity ERROR -Message  "$Error[0].InvocationInfo.line"
} # End catch statement









Stop-Transcript
