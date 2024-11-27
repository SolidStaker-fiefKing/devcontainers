DevContainers Repository

A base image/container branch: toolUp, is a Docker Container with Node.js server/runtime on top of Ubuntu 24.04 LTS with Rust (for heaving logic) and powershell 7 with basic modules for Microsoft services (EXO, PNP, Graph, etc) for the payload content creation. Extensions for VS code. Not ready for API development (sdk missing on purpose in the base toolUp image/branch). 

This is Most likely a rather non-conventional repo. The branch are lateral not vertical. In order to make sense of it, use the branch name and the ReadMe file (around line 3).

This branch; with its dockerfile & devcontainer.json file can be used to target Microsoft cloud services or on-prem windows servers or both. If you intended to target API's specifically, catch the very next branch/image [tuldAPIready].