# Use an official Node runtime as a parent image
FROM node:16 AS builder

# Create app directory
WORKDIR /frontend

# Copy only the package files first to install dependencies
COPY frontend/package.json frontend/package-lock.json ./

# Install dependencies
RUN npm install

# Now copy the rest of your frontend code
COPY frontend/ .

# Build your app
RUN npm run build

# Optionally, switch to a lighter image (like nginx) for serving your build
FROM nginx:latest
COPY --from=builder /frontend/build /usr/share/nginx/html

