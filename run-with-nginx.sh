#!/bin/bash

# This script is a simple process manager for the container.
# It starts all necessary services in the background and then waits.

# Start the X virtual frame buffer
Xvfb :99 -screen 0 ${Xvfb_WIDTH:-1920}x${Xvfb_HEIGHT:-1080}x16 &

# Start the Fluxbox window manager
fluxbox &

# Start the VNC server
x11vnc -display :99 -nopw -forever -shared &

# Start the web socket proxy for noVNC
websockify --web /usr/share/novnc 6080 localhost:5900 &

# Start nginx for DevTools reverse proxy
nginx -g "daemon off;" &

# Run the Node.js script that launches the browser
node /app/index.js &

# Wait for a moment to ensure Chrome starts
sleep 5

echo "All services started:"
echo "- noVNC: http://localhost:6080"
echo "- DevTools (direct): http://localhost:9223"
echo "- DevTools (via nginx): http://localhost:8080"

# This `wait` command ensures that the script keeps running
# as long as any of the background processes are still active.
wait