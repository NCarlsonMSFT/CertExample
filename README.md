# CertExample
Example for supporting service to service communication over HTTPS in local container debugging.

## Highlights
### [CreateCerts.sh](Certs/CreateCerts.sh)
Creates a self-signed certificate to act as a CA and certificates for the front end and back end services signed by the self-signed certificate.
### [Create-Certs.ps1](Certs/Create-Certs.ps1)
Runs [CreateCerts.sh](Certs/CreateCerts.sh) in a container, trusting the generated self-signed certificate as a root CA for the current user, and generating .env files to configure the services to use the test certificates.
### CreateCerts target in [BackEnd\BackEnd.csproj](BackEnd/BackEnd.csproj)
This target handles running Create-Certs.ps1 when the project is opened or built in VS (so you don't have to remember to run the script before opening the project)
### testCerts stage in [BackEnd\Dockerfile](BackEnd/Dockerfile) / [FrontEnd\Dockerfile](FrontEnd/Dockerfile)
This stage adds the self-signed certificate as a trusted certificate authority in the containers.
### [ContainerCerts.props](ContainerCerts.props)
Properties to customize Docker debugging to use the testCerts stage and the generated files. [Docs](https://docs.microsoft.com/en-us/visualstudio/containers/container-msbuild-properties?view=vs-2022)
### [docker-compose.vs.debug.yml](docker-compose.vs.debug.yml)
Compose file to customize Docker Compose debugging to use the testCerts stage and the generated files. [Docs](https://docs.microsoft.com/en-us/visualstudio/containers/docker-compose-properties?view=vs-2022#overriding-visual-studios-docker-compose-configuration)