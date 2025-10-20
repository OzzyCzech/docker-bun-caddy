##############################################################
# Prepare Caddy with xcaddy
##############################################################

FROM caddy:builder AS caddy
RUN xcaddy build --with github.com/baldinof/caddy-supervisor


##############################################################
# Application Build Stage
##############################################################

FROM oven/bun:alpine AS build
WORKDIR /app

COPY package.json package.json
COPY bun.lock bun.lock
COPY index.ts index.ts

ENV NODE_ENV=production

# Install dependencies
RUN bun install --frozen-lockfile

# Build the project

RUN bun build \
	--compile \
	--minify-whitespace \
	--minify-syntax \
	--outfile myserver \
	index.ts &&  \
    chmod +x myserver

##############################################################
# Aplication Stage
##############################################################

FROM oven/bun:alpine AS bun-app

# Copy Caddy binary from the caddy builder stage
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
# Copy Caddyfile configuration to the image
COPY .docker/Caddyfile /etc/caddy/Caddyfile

# Copy the application from the build stage
COPY --from=build /app/myserver /usr/local/bin/myserver

ENV NODE_ENV=production

# Set the working directory
WORKDIR /app

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Start Caddy server with the specified configuration
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]