#Global Variables
$dnsHost = "192.168.137.128"
$dnsUser = "administrator"
$dnsPwd = "VMware1!"
$csv_location = "E:\Users\Jim\Documents\Git\Projects\Add_DNS\add_dns.csv"
$servers = Import-CSV $csv_location

#Create secure credentials to pass to Windows DNS Server
$secPwd = ConvertTo-SecureString $dnsPwd -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($dnsUser,$secPwd)

#Create a PowerShell session to the specified DNS Server. Otherwise, the script attempts to use the local computer DNS configuration where the script is being run to connect.
$ps = New-PSSession -ComputerName $dnsHost -Credential $creds

#Create DNS A and PTR records on specified DNS Server
$servers | ForEach-Object {
    Invoke-Command -Session $ps -ScriptBlock {param($obj) Add-DnsServerResourceRecordA -ZoneName $obj.zone -Name $obj.name -IPv4Address $obj.ip -AllowUpdateAny -CreatePtr} -ArgumentList $_
    Write-Host $_
}