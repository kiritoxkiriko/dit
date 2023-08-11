# Dit(docker-image-transfer)
A docker image transfer shell script, help u pull, retag, reupload to from one image registry to another

## Installation
```shell
wget  ./dit
chmod +x ./dit
mv ./dit /usr/local/bin
```
## Usage
```shell
dit -p mypullregistry -u mypushregistry -i image1,image2,image3
# show help
dit -h
```
## Examples
Pull ubuntu image from offical dockerhub and reupload to ghcr.io
```shell
dit -u "ghcr.io/kiritoxkiriko" -i "ubuntu:20.04,ubuntu:22.04"
```
