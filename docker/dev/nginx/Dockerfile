# Stage 1: Build Frontend
FROM node:20-alpine AS frontend-builder

WORKDIR /app

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ ./

ARG VITE_API_BASE_URL
ARG VITE_SERVER_URL
ARG VITE_CLIENT_URL
ARG VITE_PAYPAL_CLIENT_ID
ARG VITE_CURRENCY_SIGN
ARG VITE_COOKIE_DOMAIN

ENV VITE_API_BASE_URL=$VITE_API_BASE_URL
ENV VITE_SERVER_URL=$VITE_SERVER_URL
ENV VITE_CLIENT_URL=$VITE_CLIENT_URL
ENV VITE_PAYPAL_CLIENT_ID=$VITE_PAYPAL_CLIENT_ID
ENV VITE_CURRENCY_SIGN=$VITE_CURRENCY_SIGN
ENV VITE_COOKIE_DOMAIN=$VITE_COOKIE_DOMAIN

RUN npm run build

# Stage 2: Nginx
FROM nginx:1.28.0-alpine3.21-slim

RUN rm /etc/nginx/conf.d/default.conf 

COPY ./docker/dev/nginx/nginx.conf /etc/nginx/conf.d/default.conf 

COPY --from=frontend-builder /app/dist /usr/share/nginx/html