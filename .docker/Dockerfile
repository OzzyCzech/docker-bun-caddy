##############################################################
# Prepare Caddy with xcaddy
##############################################################

FROM caddy:builder AS caddy
RUN xcaddy build --with github.com/baldinof/caddy-supervisor


##############################################################
# Application Build Stage
##############################################################

FROM oven/bun AS build

WORKDIR /app
COPY . .

RUN bun install --frozen-lockfile

##############################################################
# Aplication Stage
##############################################################

FROM oven/bun AS bun-app

# Copy Caddy binary from the caddy builder stage
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy

# Copy the application from the build stage
COPY --from=build /app /app

# Copy Caddyfile configuration to the image
COPY .docker/Caddyfile /etc/caddy/Caddyfile

# Set the working directory
WORKDIR /app

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Start Caddy server with the specified configuration
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]