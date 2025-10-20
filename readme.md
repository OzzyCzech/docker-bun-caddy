# Docker & Bun & Caddy

This project demonstrates how to set up a [Docker](https://www.docker.com/) container running a [Bun](https://bun.com)
application with [Caddy](https://caddyserver.com/) as a reverse proxy. With auto TLS certificates provided
by [Let's Encrypt](https://letsencrypt.org/).

This project **combine Bun and Caddy server** inside single Docker container. This is against the best practices, but it
is done here for simplicity and demonstration purposes. In production, it is recommended to separate concerns by using
different containers for the application and the web server.

## Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your machine.
- A domain name pointing to your server's IP address (for TLS).

## Project Structure

```text
.
├── .docker
│   ├── Dockerfile        # Dockerfile to build the image
│   └── Caddyfile         # Caddy configuration file
├── index.ts              # Main entry point for the Bun application
├── docker-bake.hcl       # Docker Buildx bake file for multi-platform builds
├── package.json          # Bun project configuration
└── readme.md             # This readme file
```

## Build the Docker Image

We are using multi-platform, multi-stage build to create a small image with Bun, Caddy and application code only. Check
`Dockerfile` and `docker-bake.hcl` for more details.

```shell
docker buildx bake \
  bun-app \
  --file docker-bake.hcl \  
  --no-cache \
  --push # Push to Docker Hub
```

If you want to load image into local Docker image store, add `--load` flag, but you have to specify only one platform
with `--set target.platform=linux/arm64` (or `linux/amd64` for Intel).

```shell
docker buildx bake \
  bun-app \
  --file docker-bake.hcl \
  --set bun-app.platform=linux/arm64 \
  --no-cache \
  --load
```

## Run the Docker Container

```shell
docker run --rm \
  -p "80:80" \
  -p "443:443" \
  -e DOMAIN="https://localhost" \
  bun-app:latest
```

Then open your browser and navigate to `https://localhost/` to see the Bun application running behind Caddy.

See how to add certificates to trusted store if you are using self-signed certificates.
https://caddyserver.com/docs/running#local-https-with-docker

## Change Caddy Configuration

On the server you need specify the domain to obtain TLS certificates from Let's Encrypt. You can do this by modifying
the `Caddyfile` located in the `.docker` directory.

```shell
docker run --rm \
  -p "80:80" \
  -p "443:443" \
  -e DOMAIN=your-server.com \
  bun-app:latest
```

Or you can update `Caddyfile` and rebuild the image.