$OriginalData = Get-Content("C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config")
$OriginalEnd = '</configuration>'
$TempEnd = '<system.net><defaultProxy enabled="true" useDefaultCredentials="true"><proxy usesystemdefault="true" proxyaddress="PROXYDETAILSHERE:PORT" bypassonlocal="true"/></defaultProxy></system.net></configuration>'
$TempData = $OriginalData -replace $OriginalEnd,$TempEnd

If ((Get-DAConnectionStatus).Status -ne "ConnectedRemotely")
{
    If (!($OriginalData -like "*proxyaddress=*"))
    {
        If ($OriginalData -like "</configuration>")
        {
            Set-Content -Path "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" -Value $TempData
        }
    }
}
.\OPPTransition.exe -Tenant TENANTUUID -Key KEYUUID -Domain DOMAIN
$CorrectedData = $TempData -replace $TempEnd,$OriginalEnd
Set-Content -Path "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\machine.config" -Value $CorrectedData
