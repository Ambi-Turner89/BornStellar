param(
    [String]$username,
    [String]$pwd
)

# Email Notification 



$smtp       = "smtp.office365.com"
$port          = '587'
$from       = "SaaSInfrastructureOps@duckcreek.com"
$to1         = "PERSON1"
#$to2        = "PERSON2"


Write-Host "username is " $username

#$username   = "$(SaaSInfrastructureOpsUsername)"
#$pwd        = "$(SaaSInfrastructureOpsPassword)"


try
{ 
$ErrorActionPreference = "continue"

$subject = "[SUCCESS] Dynatrace OneAgent has been installed on $env:server " 

$emailBody = @"
<html><body>
<p> One agent Installation completed for <b>$env:server</b>
<br>
<br><b>Servername:</b>$env:server
<br><b>Customer Name:</b> $env:customername
<br><b>Created By:</b> $env:createdby
<br>
</body></html>
"@

$MailMessage = New-Object System.Net.Mail.MailMessage
$MailMessage.IsBodyHtml = $true
$SMTPClient = New-Object System.Net.Mail.smtpClient
$SMTPClient.host = $smtp
$SMTPClient.port = $port
$SMTPClient.EnableSsl=$true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($username, $pwd)
$Recipient1 = New-Object System.Net.Mail.MailAddress($to1)
#$Recipient2 = New-Object System.Net.Mail.MailAddress($to2)
$Sender = New-Object System.Net.Mail.MailAddress($from)


$MailMessage.Subject = $subject
$MailMessage.Sender = $Sender
$MailMessage.From = $Sender
$MailMessage.To.add($Recipient1)
#$MailMessage.To.add($Recipient2)
$MailMessage.Body = $emailBody
$SMTPClient.Send($MailMessage)


}
catch [system.exception]
{
Write-Host "caught a system exception"
Write-Host $_
}
finally
{

Write-Host "Email Sent to monitoring"
}



#update logic app per randy
$Url = "https://prod-18.northcentralus.logic.azure.com:443/workflows/ff940a419b4b4d04880bd123b9276d42/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=OB8wVmXm_z6aDTbJoDVFJ64qbuddbFTxw_vFe-Jc1a8"

$Body = @{
    CreatedBy =  "$env:createdby"
    customername =   "$env:customername"
    customernumber =   "$env:customernumber"
    customerid =   "$env:customerid"
    workitemid =   "$workitemid"
    workitemstatus =   "$workitemstatus" 
    workitemcomment =   "$workitemcomment"
    workitemtype =   "$workitemtype" 
    region =   "$env:region"
    InfraEnvironment =   "$env:infraenvironment"

}
$json = $body | ConvertTo-Json







