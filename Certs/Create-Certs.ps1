[string]$Password = [Guid]::NewGuid().ToString("N")
Set-Content -Path "${PSScriptRoot}\Password.txt" -Value $Password -NoNewline

docker run --entrypoint="/bin/bash" -v "${PSScriptRoot}:/Certs" -w="/Certs" mcr.microsoft.com/dotnet/aspnet:3.1 "/Certs/CreateCerts.sh"

$composeTemplate = Get-Content -Path "${PSScriptRoot}\docker-compose.vs.debug.yml.template"
$composeText = $composeTemplate.Replace("`$Password", $Password)
Set-Content -Path "${PSScriptRoot}\..\docker-compose.vs.debug.yml" -Value $composeText


$testCaCert = New-Object -TypeName "System.Security.Cryptography.X509Certificates.X509Certificate2" @("${PSScriptRoot}\test-ca.crt", $null)

$storeName = [System.Security.Cryptography.X509Certificates.StoreName]::Root;
$storeLocation = [System.Security.Cryptography.X509Certificates.StoreLocation]::CurrentUser
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store($storeName, $storeLocation)
$store.Open(([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite))
try
{
    $store.Add($testCaCert)
}
finally
{
    $store.Close()
    $store.Dispose()
}
