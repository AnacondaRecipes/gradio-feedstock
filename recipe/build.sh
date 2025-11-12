#!/bin/bash

set -e  # Exit on any error

echo "Node.js version: $(node --version)"
echo "pnpm version: $(pnpm --version)"

# First install the Python package (needed for frontend build)
echo "Installing package with pip first..."
$PYTHON -m pip install . -vv --no-deps --no-build-isolation

# Check if the build_frontend script exists
if [ -f "scripts/build_frontend.sh" ]; then
    echo "Found scripts/build_frontend.sh, building frontend..."
    chmod +x scripts/build_frontend.sh

    # Set Node.js memory options
    export NODE_OPTIONS="--max-old-space-size=8192"

    # Build the frontend
    ./scripts/build_frontend.sh

    # Reinstall to include the built frontend
    echo "Reinstalling package to include built frontend..."
    $PYTHON -m pip install . -vv --no-deps --no-build-isolation --force-reinstall
else
    echo "Warning: scripts/build_frontend.sh not found, skipping frontend build"
fi