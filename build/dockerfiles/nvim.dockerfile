FROM linuxcontainers/debian-slim:latest

# The build context is assumed to be the build-context folder under the parent dir of this file's dir.
COPY * ./

RUN ./entrypoint.py --docker

entrypoint ["nvim"]
