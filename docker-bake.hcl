# Define the Docker Compose services block
# https://docs.docker.com/build/bake/reference/

variable "TAG" {
  default = "latest"
}

######################################################################
# docker buildx bake --file docker-bake.hcl bun-app --no-cache --push
######################################################################

target "bun-app" {
  # Build context directory (prevent using full path in Dockerfile COPY statements)
  context = "."

  # Path to the Dockerfile
  dockerfile = ".docker/Dockerfile"

  # Target stage to build from the Dockerfile
  target = "bun-app"

  # Build for multiple platforms (e.g., linux/amd64 and linux/arm64)
  platforms = ["linux/amd64", "linux/arm64"]

  # Always attempt to pull a newer version of the base image
  pull = true

  # Push the built image to the registry
  tags = [
    # You can specify multiple tags or Docker registries here
    # https://docs.docker.com/engine/reference/commandline/buildx_bake/#options
    "docker.io/username/bun-app:${TAG}",
    "bun-app:${TAG}"
  ]
}