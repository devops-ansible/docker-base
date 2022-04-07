ARG IMAGE="ubuntu"
ARG VERSION="20.04"

FROM "${IMAGE}:${VERSION}"

MAINTAINER macwinnie <dev@macwinnie.me>

# environmental variables
ENV TERM            "xterm"
ENV DEBIAN_FRONTEND "noninteractive"
ENV TIMEZONE        "Europe/Berlin"
ENV SET_LOCALE      "de_DE.UTF-8"
ENV START_CRON      0
ENV CRON_PATH       "/etc/cron.d/docker"
ENV EDITOR          "vim"

ARG JDK_NAME="temurin-17-jdk"
ENV JDK_NAME "${JDK_NAME}"

# copy all relevant files
COPY files/ /

# organise file permissions and run installer
RUN chmod a+x /install.sh && \
    /install.sh && \
    rm -f /install.sh

# run on every (re)start of container
ENTRYPOINT [ "entrypoint" ]
CMD [ "sleep infinity" ]
