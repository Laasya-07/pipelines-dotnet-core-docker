# First stage of multi-stage build
FROM microsoft/aspnetcore-build AS build-env
WORKDIR /

# copy the contents of agent working directory on host to workdir in container
COPY . ./

# dotnet commands to build, test, and publish
RUN dotnet restore
RUN dotnet build -c Release
RUN dotnet publish -c Release -o out

# Second stage - Build runtime image
FROM microsoft/aspnetcore
WORKDIR /
COPY --from=build-env / .
ENTRYPOINT ["dotnet", "pipelines-dotnet-core-docker.dll"]
