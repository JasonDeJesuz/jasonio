# NuGet restore
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /
COPY *.sln ./
# COPY Colors.UnitTests/*.csproj Colors.UnitTests/
COPY *.csproj .
RUN dotnet restore
COPY . .

# testing
FROM build AS testing
WORKDIR /
RUN dotnet build
# WORKDIR /src/Colors.UnitTests
# RUN dotnet test

# publish
FROM build AS publish
WORKDIR /
RUN dotnet publish -c Release -o /src/publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=publish /src/publish .
# ENTRYPOINT ["dotnet", "Colors.API.dll"]
# heroku uses the following
CMD ASPNETCORE_URLS=http://*:$PORT dotnet jasonio.dll
