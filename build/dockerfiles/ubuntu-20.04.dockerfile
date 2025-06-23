FROM python:3.10-bullseye


WORKDIR src

# The build context is assumed to be the build-context folder under the parent dir of this file's dir.
COPY * ./

entrypoint ["env-install.py"]
