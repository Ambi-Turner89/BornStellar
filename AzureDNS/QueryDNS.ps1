<########################################################################################################################################################
    Name: Query-AZDNS.Util.ps1
    Author: Randy Bordeaux 
    Date Created: 10/21/2021
    Date Modified:f 
    Description: 
        Query Azure DNS Zone Records
        
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
$error.clear()

<#param(
    [Parameter(Mandatory = $False)]
    [string]$dnsrecordname,
    [Parameter(Mandatory = $False)]
    [string]$newdnsrecordurl
)
#>
<# Variables enu04. uncu96* #>
$dnsrecordname = 'uncp46'   # for testing 
$zonename = 'duckcreekondemand.com'
$rgname = 'unc-shr-01-dmz-01-rg'

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

    [pscustomobject]@{
        Date     = (Get-Date -Format 'MM-dd-yyyy')
        Time     = (Get-Date -Format 'HH:mm')
        Severity = $Severity
        Message  = $Message
    } | Export-Csv -Path "$logDir\$(Get-Date -Format MM-dd-yyyy)-$($logFileName).txt" -Append -NoTypeInformation
} # End of function Write-Log 


<# Set Subscription #>
#Set-AzContext -Subscription 'Duck Creek On Demand Production'
Set-AzContext -Subscription 'Duck Creek On Demand Shared'
#Set-AzContext -Subscription 'Duck Creek On Demand POC'
#Set-AzContext -Subscription 'Duck Creek On Demand Development'
#Set-AzContext -Subscription 'Duck Creek On Demand UAT/Pre-Production'

<# Query DNS #>
Try {
    Get-AzDnsRecordSet -RecordType CNAME -ZoneName $zonename -ResourceGroupName $rgname `
    | Where-Object Name -Like $dnsrecordname | Format-Table Name, Records 
}

Catch {
    Write-Log -Severity ERROR -Message "Error trying to get $dnsrecordname"
    Write-Log -Severity ERROR -Message  "$Error[0].InvocationInfo.line"
} # End catch statement

#  





