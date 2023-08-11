#!/bin/bash

# Initialize our own variables
pull_registry=""
push_registry=""
images=""

# Display help function
display_help() {
    echo "Usage: $0 [options...]" >&2
    echo
    echo "   -p, --pull-registry    The registry to pull the images from."
    echo "   -u, --push-registry    The registry to push the images to."
    echo "   -i, --images           A comma-separated list of images to transfer."
    echo
    echo "Example: $0 -p mypullregistry -u mypushregistry -i image1,image2,image3"
    echo "Example: $0 --pull-registry mypullregistry --push-registry mypushregistry --images image1,image2,image3"
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
if [ -z "$pull_registry" ] || [ -z "$push_registry" ] || [ -z "$images" ]; then
    echo "Error: Not all required arguments are provided."
    display_help
fi

# Convert the images string into an array
IFS=',' read -ra images_array <<< "$images"

# Loop through each image
for image in "${images_array[@]}"; do
    # Pull the image
    docker pull $pull_registry/$image

    # Retag the image
    docker tag $pull_registry/$image $push_registry/$image

    # Push the image
    docker push $push_registry/$image
done

echo "All images have been pulled, retagged, and pushed successfully."
