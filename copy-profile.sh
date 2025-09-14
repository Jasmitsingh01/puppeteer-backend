#!/bin/bash

# This script copies essential Chrome profile files to the container

# Create profile directory if it doesn't exist
mkdir -p /app/my-profile

# Copy essential profile files
cp -r /app/profile-data/* /app/my-profile/

# Set proper permissions
chmod -R 777 /app/my-profile

echo "Chrome profile copied successfully"