# Remove all Root certificates from Contoso
Get-ChildItem -Path Cert:\CurrentUser\Root\ | Where-Object -Property Subject -EQ "O=Contoso" | Remove-Item