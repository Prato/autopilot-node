FROM prato/autopilot-base:next

RUN apk update && apk add \
        nodejs \
    && rm -rf /var/cache/apk/*
