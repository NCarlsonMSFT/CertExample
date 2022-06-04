[string]$Password = [Guid]::NewGuid().ToString("N")
Set-Content -Path "${PSScriptRoot}\Password.txt" -Value $Password -NoNewline

docker run --rm --entrypoint="/bin/bash" -v "${PSScriptRoot}:/Certs" -w="/Certs" mcr.microsoft.com/dotnet/aspnet:3.1 "/Certs/CreateCerts.sh"

$envTemplate = Get-Content -Path "${PSScriptRoot}\ContainerCerts.env.template"
$envWPassword = $envTemplate.Replace("`$Password", $Password)
$frontEndEnv = $envWPassword.Replace("`$ProjectName", "frontend")
Set-Content -Path "${PSScriptRoot}\..\FrontEnd\ContainerCerts.env" -Value $frontEndEnv
$backEndEnv = $envWPassword.Replace("`$ProjectName", "backend")
Set-Content -Path "${PSScriptRoot}\..\BackEnd\ContainerCerts.env" -Value $backEndEnv

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
