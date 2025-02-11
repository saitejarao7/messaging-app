FROM node:16 AS builder
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build && ls -la /frontend

FROM nginx:latest
COPY --from=builder /frontend/dist /usr/share/nginx/html
