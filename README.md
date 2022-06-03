# CertExample
Example for supporting secure service to service communication in local debugging

## Highlights
### [CreateCerts.sh](Certs/CreateCerts.sh)
Creates a self-signed certificate and certificates for the front end and back end that are signed by the self-signed certificate
### [Create-Certs.ps1](Certs/Create-Certs.ps1)
This handles running [CreateCerts.sh](Certs/CreateCerts.sh) in a container, trusting the generated self-signed certificate as a root CA for the current user, and generating a docker-compose.vs.debug.yml file to configure the services to use the test certificates
### testCerts stage in [BackEnd/Dockerfile](BackEnd/Dockerfile) / [FrontEnd/Dockerfile](FrontEnd/Dockerfile)
This stage handles adding the self-signed certificate as a trusted certificate authority in the container
### CreateCerts target in [docker-compose.dcproj](docker-compose.dcproj)
This target handles running Create-Certs.ps1 when the project is built (so you don't have to remember to run the script before opening the project)
