FROM nginx:1.28.0-alpine3.21-slim

RUN rm /etc/nginx/conf.d/default.conf

COPY ./docker/dev/monitoring/nginx/nginx.conf /etc/nginx/conf.d/default.conf