#!/bin/bash

# Set up environment
export DISPLAY=:1

# Create .vnc directory if it doesn't exist
mkdir -p ~/.vnc

# Wait a moment for services to initialize
echo "Starting services..."

# Start supervisor which will manage all services
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf