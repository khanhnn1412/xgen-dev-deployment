#!/bin/bash

# Script to copy deployment files to a new folder
# Usage: ./copy_deployment_files.sh [target_folder]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Check if target folder is provided
TARGET_FOLDER=${1:-"../techx-genai-platform-new"}

print_header "Copying deployment files to $TARGET_FOLDER"

# Check if source files exist
if [ ! -f "src/dev.sh" ]; then
    print_error "dev.sh not found in src/"
    exit 1
fi

if [ ! -f "src/docker-compose.dev.yaml" ]; then
    print_error "docker-compose.dev.yaml not found in src/"
    exit 1
fi

# Create target directory
mkdir -p "$TARGET_FOLDER"
print_status "Created target directory: $TARGET_FOLDER"

# Copy main deployment files
print_status "Copying main deployment files..."

cp src/dev.sh "$TARGET_FOLDER/src/"
cp src/docker-compose.dev.yaml "$TARGET_FOLDER/src"

# Create service directories
mkdir -p "$TARGET_FOLDER/src/backend"
mkdir -p "$TARGET_FOLDER/src/inference_engine"
mkdir -p "$TARGET_FOLDER/src/ingestion"
mkdir -p "$TARGET_FOLDER/src/website"
mkdir -p "$TARGET_FOLDER/src/embed-chatbot"

print_status "Created service directories"

# Copy Dockerfile.dev files if they exist
print_status "Copying Dockerfile.dev files..."

# Backend
if [ -f "src/backend/Dockerfile.dev" ]; then
    cp src/backend/Dockerfile.dev "$TARGET_FOLDER/src/backend/"
    print_status "✓ Copied backend/Dockerfile.dev"
else
    print_warning "backend/Dockerfile.dev not found, skipping"
fi

# Inference
if [ -f "src/inference_engine/Dockerfile.dev" ]; then
    cp src/inference_engine/Dockerfile.dev "$TARGET_FOLDER/src/inference_engine/"
    print_status "✓ Copied inference_engine/Dockerfile.dev"
else
    print_warning "inference_engine/Dockerfile.dev not found, skipping"
fi

# Ingestion
if [ -f "src/ingestion/Dockerfile.dev" ]; then
    cp src/ingestion/Dockerfile.dev "$TARGET_FOLDER/src/ingestion/"
    print_status "✓ Copied ingestion/Dockerfile.dev"
else
    print_warning "ingestion/Dockerfile.dev not found, skipping"
fi

# Website
if [ -f "src/website/Dockerfile.dev" ]; then
    cp src/website/Dockerfile.dev "$TARGET_FOLDER/src/website/"
    print_status "✓ Copied website/Dockerfile.dev"
else
    print_warning "website/Dockerfile.dev not found, skipping"
fi

# Embed-chatbot
if [ -f "src/embed-chatbot/Dockerfile.dev" ]; then
    cp src/website/Dockerfile.dev "$TARGET_FOLDER/src/embed-chatbot/"
    print_status "✓ Copied embed-chatbot/Dockerfile.dev"
else
    print_warning "embed-chatbot/Dockerfile.dev not found, skipping"
fi

# Make dev.sh executable
chmod +x "$TARGET_FOLDER/src/dev.sh"

print_header "Deployment files copied successfully!"

print_status "Files copied to $TARGET_FOLDER:"
echo "  - dev.sh"
echo "  - docker-compose.dev.yaml"
echo "  - src/backend/Dockerfile.dev (if exists)"
echo "  - src/inference_engine/Dockerfile.dev (if exists)"
echo "  - src/ingestion/Dockerfile.dev (if exists)"
echo "  - src/website/Dockerfile.dev (if exists)"
echo "  - src/embed-chatbot/Dockerfile.dev (if exists)"

print_status "Next steps:"
echo "  1. Copy your source code to the src/ directories"
echo "  2. Run './dev.sh setup' to build containers"
echo "  3. Run './dev.sh start' to start services"

print_status "Target folder: $TARGET_FOLDER"

