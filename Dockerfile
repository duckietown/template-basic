# parameters
ARG REPO_NAME="<REPO_NAME_HERE>"

# ==================================================>
# ==> Do not change this code
ARG ARCH=arm64v8
ARG MAJOR=ente
ARG BASE_TAG=${MAJOR}-${ARCH}
ARG BASE_IMAGE=dt-commons

# define base image
ARG DOCKER_REGISTRY=docker.io
FROM ${DOCKER_REGISTRY}/duckietown/${BASE_IMAGE}:${BASE_TAG}

# check REPO_NAME
ARG REPO_NAME
RUN bash -c \
  'if [ "${REPO_NAME}" = "<REPO_NAME_HERE>" ]; then \
    >&2 echo "ERROR: You need to change the value of REPO_NAME inside Dockerfile."; \
    exit 1; \
  fi'

# define repository path
ARG REPO_PATH="${SOURCE_DIR}/${REPO_NAME}"
WORKDIR "${REPO_PATH}"

# create repo directory
RUN mkdir -p "${REPO_PATH}"

# copy dependencies (APT)
COPY ./dependencies-apt.txt "${REPO_PATH}/"

# install apt dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    $(awk -F: '/^[^#]/ { print $1 }' dependencies-apt.txt | uniq) \
  && rm -rf /var/lib/apt/lists/*

# copy dependencies (PIP3)
COPY ./dependencies-py3.txt "${REPO_PATH}/"

# install python dependencies
RUN pip3 install -r ${REPO_PATH}/dependencies-py3.txt

# copy the source code
COPY ./code/. "${REPO_PATH}/"

# copy avahi services
COPY ./assets/avahi-services/. /avahi-services/

# define launch script
COPY ./launch.sh "${REPO_PATH}/"
ENV LAUNCHFILE "${REPO_PATH}/launch.sh"

# define command
CMD ["bash", "-c", "${LAUNCHFILE}"]

# store module name
LABEL org.duckietown.label.module.type "${REPO_NAME}"
ENV DT_MODULE_TYPE "${REPO_NAME}"

# store module metadata
ARG ARCH
ARG MAJOR
ARG BASE_TAG
ARG BASE_IMAGE
LABEL org.duckietown.label.architecture "${ARCH}"
LABEL org.duckietown.label.code.location "${REPO_PATH}"
LABEL org.duckietown.label.code.version.major "${MAJOR}"
LABEL org.duckietown.label.base.image "${BASE_IMAGE}:${BASE_TAG}"
# <== Do not change this code
# <==================================================

# maintainer
LABEL maintainer="<YOUR_FULL_NAME> (<YOUR_EMAIL_ADDRESS>)"
