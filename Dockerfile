ARG VERSION

FROM debian:stable-slim as installer
ARG VERSION

RUN apt-get update && apt-get install -y curl

RUN curl -sSL https://rover.apollo.dev/nix/${VERSION} | sh

FROM debian:stable-slim as runner
ARG VERSION

COPY --from=installer /root/.rover/bin/rover /root/.rover/bin/rover
ENV PATH="/root/.rover/bin:${PATH}"
ENV ROVER_VERSION=$VERSION

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/* && apt-get clean

ENTRYPOINT [ "/root/.rover/bin/rover" ]