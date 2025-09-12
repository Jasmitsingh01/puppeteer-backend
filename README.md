# Puppeteer Docker with GUI Support

This project runs a Puppeteer application in Docker with GUI support through VNC and noVNC, allowing you to view the browser interface through a web browser.

## Features

- Puppeteer with stealth plugin
- Docker containerization
- VNC server for GUI access
- noVNC web interface for browser-based access
- Remote debugging support

## Quick Start

### Using Docker Compose (Recommended)

1. Build and run the container:
```bash
docker-compose up --build
```

2. Access the browser GUI:
   - **Web Interface (noVNC)**: Open http://localhost or http://localhost:8080 in your browser
   - **VNC Client**: Connect to localhost:5900
   - **Remote Debugging**: Chrome DevTools at http://localhost/devtools/inspector.html
   - **WebSocket Endpoint**: Available at ws://localhost/ws for external connections

### Using Docker directly

1. Build the image:
```bash
docker build -t puppeteer-gui .
```

2. Run the container:
```bash
docker run -p 6080:6080 -p 5900:5900 -p 9223:9223 --shm-size=2g --security-opt seccomp=unconfined --cap-add=SYS_ADMIN puppeteer-gui
```

## Ports

- **80**: nginx reverse proxy (main access point)
- **8080**: Alternative HTTP port for nginx
- **5900**: VNC server (direct access)
- Internal ports (6080, 9223) are proxied through nginx

## Environment Variables

- `SCREEN_WIDTH`: Screen width (default: 1280)
- `SCREEN_HEIGHT`: Screen height (default: 720)
- `SCREEN_DEPTH`: Color depth (default: 24)
- `VNC_PORT`: VNC port (default: 5900)
- `NOVNC_PORT`: noVNC port (default: 6080)

## Output Files

The application creates:
- `wsEndpoint.txt`: Internal WebSocket endpoint
- `output/endpoints.json`: Complete endpoint information including external URLs
- Any other output files will be available in the `./output` directory on the host.

## External Access

The nginx reverse proxy provides external access to all services:
- **noVNC Web Interface**: http://your-server-ip
- **WebSocket Endpoint**: ws://your-server-ip/ws
- **DevTools**: http://your-server-ip/devtools/inspector.html
- **JSON API**: http://your-server-ip/json

## Troubleshooting

- If the browser doesn't start, check the logs: `docker-compose logs`
- For VNC connection issues, ensure ports are not blocked by firewall
- Chrome requires `--shm-size=2g` and security options for proper operation

## Development

To modify the application:
1. Edit `index.ts`
2. Rebuild with `docker-compose up --build`
3. Access through http://localhost:6080