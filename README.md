# Dit(docker-image-transfer)
A docker image transfer shell script, help u pull, retag, reupload to from one image registry to another
**All codes are genrated By OpenAI ChatGPT**
## Installation
```shell
wget  ./dit
chmod +x ./dit
mv ./dit /usr/local/bin
```
## Usage
```shell
dit -p mypullregistry -u mypushregistry -m linux/amd64,linux/arm64 -i image1,image2,image3
# show help
dit -h
```
## Examples
Pull ubuntu image from offical dockerhub and reupload to ghcr.io
```shell
dit -p "" -u "ghcr.io/kiritoxkiriko" -m linux/amd64 -i "ubuntu:20.04,ubuntu:22.04"
```
