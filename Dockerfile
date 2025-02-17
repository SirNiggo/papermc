FROM debian:stable AS dl

WORKDIR /download

ARG MC_VERSION
ARG PAPER_VERSION

RUN apt update && \
    apt upgrade -y && \
    apt install curl -y && \
    curl https://papermc.io/api/v2/projects/paper/versions/${MC_VERSION}/builds/${PAPER_VERSION}/downloads/paper-${MC_VERSION}-${PAPER_VERSION}.jar --output papermc.jar

FROM openjdk:16-slim-buster

EXPOSE 25565/tcp
EXPOSE 25565/udp

ARG MC_VERSION
ARG PAPER_VERSION

ENV ACCEPT_EULA=n
ENV OVERWRITE_SETTINGS=n
ENV BASE_CONFIG_DIR="/etc/papermc"
ENV SERVER_PORT=25565
ENV ONLINE_MODE=true
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseContainerSupport -XX:MaxRAMPercentage=70"

WORKDIR /paper

COPY --from=dl /download/papermc.jar /opt/paper/papermc.jar
COPY entrypoint.sh /entrypoint
COPY healthcheck.sh /healthcheck

RUN chmod +x /entrypoint && \
    chmod +x /healthcheck

CMD ["/bin/bash", "-c", "/entrypoint"]

