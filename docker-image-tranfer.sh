#!/bin/bash

# MIT License
#
# Copyright (c) 2023 kiritoxkiriko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Initialize our own variables
pull_registry=""
push_registry=""
images=""

# Display help function
display_help() {
    echo "Usage: dit [options...]" >&2
    echo
    echo "   -p, --pull-registry    The registry to pull the images from. (Optional)"
    echo "   -u, --push-registry    The registry to push the images to. (Required)"
    echo "   -i, --images           A comma-separated list of images to transfer. (Required)"
    echo
    echo "Example: dit -p mypullregistry -u mypushregistry -i image1,image2,image3"
    echo "Example: dit --pull-registry mypullregistry --push-registry mypushregistry --images image1,image2,image3"
    echo "Example: dit -u mypushregistry -i image1,image2,image3"
    echo "Example: dit --push-registry mypushregistry --images image1,image2,image3"
    exit 1
}

# Parse the arguments
while (( "$#" )); do
  case "$1" in
    -h|--help)
      display_help
      ;;
    -p|--pull-registry)
      pull_registry="$2"
      shift 2
      ;;
    -u|--push-registry)
      push_registry="$2"
      shift 2
      ;;
    -i|--images)
      images="$2"
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

# Check if all required arguments are provided
if [ -z "$push_registry" ] || [ -z "$images" ]; then
    echo "Error: Not all required arguments are provided."
    display_help
fi

# Convert the images string into an array
IFS=',' read -ra images_array <<< "$images"

# Loop through each image
for image in "${images_array[@]}"; do
    # Check if pull-registry is provided
    if [ -n "$pull_registry" ]; then
        # Pull the image
        docker pull $pull_registry/$image
        # Retag the image
        docker tag $pull_registry/$image $push_registry/$image
    else
        # Pull the image without a registry prefix
        docker pull $image
        # Retag the image
        docker tag $image $push_registry/$image
    fi

    # Push the image
    docker push $push_registry/$image
done

echo "All images have been pulled, retagged, and pushed successfully."
