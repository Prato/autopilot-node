FROM prato/autopilot-base:next

RUN apk update && apk add \
        nodejs \
    && rm -rf /var/cache/apk/*

RUN npm install \
        chai@3.0.0 \
        dummy-json@1.0.1 \
        mocha@2.2.5 \
        request@2.58.0 \
        should@9.0.2 \
        supertest@1.0.0 \
        watch@0.19.1
        body-parser@1.15.2 \
        bunyan@1.8.0 \
        co@4.6.0 \
        config@1.19.0 \
        cors@2.7.1 \
        express@4.14.0 \
        express-openapi@0.23.1 \
        handlebars@4.0.5 \
        hat: 0.0.3 \
        mailcomposer@3.9.0 \
        mailgun-js@0.7.11 \
        moment@2.13.0 \
        moment-timezone@0.5.4 \
        mongoose@4.5.1 \
        redis@2.6.2 \
        require-all@2.0.0 \
        shelljs@0.7.0 \
        sprintf-js@1.0.3 \
        stripe@4.4.0 \
        swagger@0.7.5 \
        twilio@2.9.1
