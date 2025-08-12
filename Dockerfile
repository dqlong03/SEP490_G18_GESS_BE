# ========================
# 1. Build stage
# ========================
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy file .sln và các project
COPY *.sln ./
COPY Gess.Api/*.csproj Gess.Api/
COPY GESS.Auth/*.csproj GESS.Auth/
COPY GESS.Entity/*.csproj GESS.Entity/
COPY GESS.Model/*.csproj GESS.Model/
COPY GESS.Service/*.csproj GESS.Service/
COPY Gess.Repository/*.csproj Gess.Repository/
COPY GessCommon/*.csproj GessCommon/
COPY GESS.Test/*.csproj GESS.Test/

# Restore packages
RUN dotnet restore

# Copy toàn bộ source
COPY . .

# Publish ở chế độ Release
WORKDIR /src/Gess.Api
RUN dotnet publish -c Release -o /app/publish

# ========================
# 2. Runtime stage
# ========================
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Expose cổng web API
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["dotnet", "Gess.Api.dll"]
