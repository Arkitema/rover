ARG VERSION

FROM alpine:3.18 as installer
ARG VERSION

RUN apk update && apk add curl

RUN curl -sSL https://rover.apollo.dev/nix/${VERSION} | sh

FROM alpine:3.18 as runner
ARG VERSION

COPY --from=installer /root/.rover/bin/rover /root/.rover/bin/rover
ENV PATH="/root/.rover/bin:${PATH}"
ENV ROVER_VERSION=$VERSION

RUN apk update && apk add ca-certificates

ENTRYPOINT [ "/root/.rover/bin/rover" ]