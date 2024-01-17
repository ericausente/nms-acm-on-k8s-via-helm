# Bash script that abstracts the version of NMS-IM docker images. 
# This will allow you to easily change the version or repository in the future without modifying the entire script. 
# Ensure that each Docker tag and push command completes before moving on to the next one; hence added error handling and a check for the completion status of each command. 
# It now includes a check to see if a specific version of the image already exists in the repository. 

#!/bin/bash

# Define variables
VERSION="2.15.0"
NEW_REPOSITORY="ausente"
IMAGE_NAMES=("nms-integrations" "nms-core" "nms-dpm" "nms-apigw" "nms-ingestion")

# Function to check if the image already exists in the repository
image_exists() {
    # Replace this with the command to check if the image exists in your repository
    # For example, using 'docker manifest inspect' or a specific command for your Docker registry
    # This should return 0 if exists, non-zero otherwise
    docker manifest inspect "$1" > /dev/null 2>&1
}

# Function to handle errors
handle_error() {
    echo "Error on line $1"
    exit 1
}

# Trap errors
trap 'handle_error $LINENO' ERR

# Loop through each image name
for IMAGE in "${IMAGE_NAMES[@]}"; do
    FULL_IMAGE_NAME="${NEW_REPOSITORY}/${IMAGE}:${VERSION}"
    
    # Check if the image already exists
    if image_exists "${FULL_IMAGE_NAME}"; then
        echo "Image ${FULL_IMAGE_NAME} already exists. Skipping..."
        continue
    fi

    # Tag the image
    docker tag "${IMAGE}:${VERSION}" "${FULL_IMAGE_NAME}"
    echo "Tagged ${IMAGE}:${VERSION} as ${FULL_IMAGE_NAME}"
    
    # Push the image
    docker push "${FULL_IMAGE_NAME}"
    echo "Pushed ${FULL_IMAGE_NAME}"
done

echo "All images have been processed."
