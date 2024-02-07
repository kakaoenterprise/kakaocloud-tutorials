# base-stage
FROM docker.io/library/nginx:1.23.4-alpine3.17-slim AS base
RUN apk update && \
    apk add --no-cache gettext

# build-stage
FROM docker.io/library/node:18.19.0-alpine AS builder

WORKDIR '/app'

COPY . ./

RUN npm install -f
RUN sed -i "s/\"http:\/\/localhost:8080\"/window.location.origin/g" ./src/config.js

RUN npm run build

# runner-stage
FROM base AS runner

ENV SERVER_ENDPOINT="http://localhost:8080"
EXPOSE 80

RUN rm /etc/nginx/conf.d/default.conf
COPY --from=builder /app/deploy/templates/nginx.conf /tmp

RUN rm /usr/share/nginx/html/index.html
COPY --from=builder /app/build /usr/share/nginx/html

COPY --from=builder /app/deploy/templates/error/* /usr/share/nginx/html/

ENTRYPOINT envsubst '$SERVER_ENDPOINT' < /tmp/nginx.conf > /etc/nginx/conf.d/nginx.conf && \
            nginx -g 'daemon off;'
