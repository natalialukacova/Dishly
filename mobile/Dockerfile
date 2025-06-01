# Use official Node.js image to serve Flutter web
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy built Flutter web files
COPY build/web .

# Install `serve` to serve static files
RUN npm install -g serve

# Expose default port
EXPOSE 8080

# Serve Flutter Web build
CMD ["serve", "-s", ".", "-l", "8080"]
