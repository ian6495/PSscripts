$Machine = Read-Host -Prompt �Input the Machine Name�
$regpath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$regname = "AllowInsecureGuestAuth"
$regvalue = "1"

#Replace DOMAIN.LOCAL with your domain to ensure that the FQDN is queried when run

Invoke-Command -ComputerName $Machine -ScriptBlock { 
sc.exe config lanmanworkstation depend= bowser/mrxsmb10/nsi ; sc.exe config mrxsmb20 start= disabled } | ForEach-Object{ "$_.DOMAIN.LOCAL"
New-ItemProperty -Path $regpath -Name $regname -Value $regvalue -PropertyType DWORD -Force | Out-Null
Set-ItemProperty -Path $regpath -Name "EnablePlainTextPassword" -Value "0"
Set-ItemProperty -Path $regpath -Name "EnableSecuritySignature" -Value "1"
Set-ItemProperty -Path $regpath -Name "RequireSecuritySignature" -Value "1"
}