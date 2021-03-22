#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM base AS testCerts
ADD Certs/test-ca.crt /usr/local/share/ca-certificates/test-ca.crt
RUN chmod 644 /usr/local/share/ca-certificates/test-ca.crt && update-ca-certificates

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["FrontEnd/FrontEnd.csproj", "FrontEnd/"]
RUN dotnet restore "FrontEnd/FrontEnd.csproj"
COPY . .
WORKDIR "/src/FrontEnd"
RUN dotnet build "FrontEnd.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FrontEnd.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FrontEnd.dll"]
