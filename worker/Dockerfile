# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY Worker.csproj .
RUN dotnet restore

# Copy the rest of the source code and build
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/publish ./

# Set environment variables (can be overridden at runtime)
ARG DB_HOST=db
ARG DB_USERNAME=postgres
ARG DB_PASSWORD=postgres
ARG DB_NAME=postgres
ARG REDIS_HOST=redis
ENV DB_HOST=${DB_HOST}
ENV DB_USERNAME=${DB_USERNAME}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV DB_NAME=${DB_NAME}
ENV REDIS_HOST=${REDIS_HOST}

# Define the entry point
ENTRYPOINT ["dotnet", "Worker.dll"]
