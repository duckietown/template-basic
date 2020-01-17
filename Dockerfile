# parameters
ARG REPO_NAME="<REPO_NAME_HERE>"

# ==================================================>
# ==> Do not change this code
ARG ARCH=arm32v7
ARG MAJOR=daffy
ARG BASE_TAG=${MAJOR}-${ARCH}
ARG BASE_IMAGE=dt-commons

# define base image
FROM duckietown/${BASE_IMAGE}:${BASE_TAG}

# check REPO_NAME
ARG REPO_NAME
RUN bash -c \
  'if [ "${REPO_NAME}" = "<REPO_NAME_HERE>" ]; then \
    >&2 echo "ERROR: You need to change the value of REPO_NAME inside Dockerfile."; \
    exit 1; \
  fi'

# define repository path
ARG REPO_PATH="${SOURCE_DIR}/${REPO_NAME}"
ARG LAUNCH_PATH="${LAUNCH_DIR}/${REPO_NAME}"
WORKDIR "${REPO_PATH}"

# create repo directory
RUN mkdir -p "${REPO_PATH}"
RUN mkdir -p "${LAUNCH_PATH}"

# install apt dependencies
COPY ./dependencies-apt.txt "${REPO_PATH}/"
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    $(awk -F: '/^[^#]/ { print $1 }' dependencies-apt.txt | uniq) \
  && rm -rf /var/lib/apt/lists/*

# install python dependencies
COPY ./dependencies-py3.txt "${REPO_PATH}/"
RUN pip3 install -r ${REPO_PATH}/dependencies-py3.txt

# copy the source code
COPY ./code/. "${REPO_PATH}/"

# copy avahi services
COPY ./assets/avahi-services/. /avahi-services/

# define launch script
COPY ./launch.sh "${LAUNCH_PATH}/"
ENV LAUNCHFILE "${LAUNCH_PATH}/launch.sh"

# define command
CMD ["bash", "-c", "${LAUNCHFILE}"]

# store module name
LABEL org.duckietown.label.module.type="${REPO_NAME}"
ENV DT_MODULE_TYPE "${REPO_NAME}"

# store module metadata
ARG ARCH
ARG MAJOR
ARG BASE_TAG
ARG BASE_IMAGE
LABEL org.duckietown.label.architecture="${ARCH}"
LABEL org.duckietown.label.code.location="${REPO_PATH}"
LABEL org.duckietown.label.base.major="${MAJOR}"
LABEL org.duckietown.label.base.image="${BASE_IMAGE}"
LABEL org.duckietown.label.base.tag="${BASE_TAG}"
# <== Do not change this code
# <==================================================

# maintainer
LABEL maintainer="<YOUR_FULL_NAME> (<YOUR_EMAIL_ADDRESS>)"
