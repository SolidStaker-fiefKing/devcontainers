# DevContainers Repository

A phase 3 image/ branch: tuledAPIready, is a Docker Container with Node.js server/runtime on top of Ubuntu 22.04 LTS with Rust (for heavy logic) and PowerShell 7 with basic modules for Microsoft services (EXO, PNP, Graph, etc) for the payload content creation. Extensions for VS code. Very ready for API IaaCS development. Sdk will be part of post launch first efforts in the package.json file. 

This is Most likely a rather non-conventional repo. The branch are lateral not vertical. In order to make sense of it, use the branch name and the ReadMe file (around line 3).

This branch; with its dockerfile & devcontainer.json file can be used to target Microsoft cloud services or on-prem windows servers or both. If you intended to target API's and configure multiple Microsoft service, in the cloud, in the trenches; of bang out some logical magic against customer tenants then you are in the right place.

## Build the image: Dockerfile
If you are going to download the dockerfile and mod it, don't forgot to adjust the git email & user name lines (74/75). If you are going to pull the image, same thing, config those entries b/c they having placeholder data.

## Building a container: devcontainer.json
You should first set two environment variables for the git configuration commands (in the dev.json)

```PWSH
$env:GIT_USER_NAME = "Your Name"
$env:GIT_USER_EMAIL = "your-email@example.com"
```

```bash
# Set the Git user name
git config --global user.name "Your Name"

# Set the Git user email
git config --global user.email "your-email@example.com"
```

### Docker commands

```Powershell
# Build an image from a docker file
docker build -t nojs_ubun22_rpk:apiready -f NoJS_Ubun22_rpk\NoJS_Ubun22_rpk.Dockerfile .

# Ensure authentication
docker login

# Prepare to push by tagging remote image from the local image
docker tag nojs_ubun22_rpk:apiready casey2n1tech/nojs_ubun22_rpk:apiready

# Push an image
docker push casey2n1tech/nojs_ubun22_rpk:apiready
```

