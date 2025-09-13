#!/bin/bash

# This script is a simple process manager for the container.
# It starts all necessary services in the background and then waits.

# Set the DISPLAY environment variable
export DISPLAY=:99

# Clean up any existing X server locks
echo "Cleaning up X server locks..."
rm -f /tmp/.X99-lock /tmp/.X11-unix/X99

# Start the X virtual frame buffer
echo "Starting Xvfb..."
Xvfb :99 -screen 0 "${Xvfb_WIDTH:-1920}x${Xvfb_HEIGHT:-1080}x24" -ac +extension GLX +render -noreset &
XVFB_PID=$!

# Wait for X server to be ready and verify it's running
sleep 5
echo "Checking if X server is running..."
DISPLAY=:99 xdpyinfo > /dev/null 2>&1 && echo "X server is ready" || echo "X server failed to start"

# Start the Fluxbox window manager
echo "Starting Fluxbox..."
DISPLAY=:99 fluxbox &
FLUXBOX_PID=$!

# Wait for window manager
sleep 2

# Start the VNC server
echo "Starting VNC server..."
x11vnc -display :99 -nopw -forever -shared -rfbport 5900 -listen localhost &
VNC_PID=$!

# Wait for VNC server
sleep 2

# Start the web socket proxy for noVNC
echo "Starting noVNC websockify..."
websockify --web /usr/share/novnc 6080 localhost:5900 &
WEBSOCKIFY_PID=$!

# Wait for websockify
sleep 2

# Start nginx for DevTools reverse proxy
echo "Starting nginx..."
nginx -g "daemon off;" &
NGINX_PID=$!

# Wait for nginx
sleep 2

# Run the Node.js script that launches the browser
echo "Starting Node.js application..."
DISPLAY=:99 node /app/index.js &
NODE_PID=$!

# Wait for a moment to ensure Chrome starts
sleep 5

echo "All services started:"
echo "- noVNC: http://localhost:6080"
echo "- DevTools (direct): http://localhost:9223"
echo "- DevTools (via nginx): http://localhost:8080"

# Trap SIGTERM and SIGINT
trap 'kill $XVFB_PID $FLUXBOX_PID $VNC_PID $WEBSOCKIFY_PID $NGINX_PID $NODE_PID; exit' TERM INT

# This `wait` command ensures that the script keeps running
# as long as any of the background processes are still active.
wait