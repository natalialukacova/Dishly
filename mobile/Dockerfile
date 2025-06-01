# Use Flutter SDK image
FROM cirrusci/flutter:3.19.6 AS build

WORKDIR /app

# Copy entire Flutter project
COPY . .

# Enable web support (if needed)
RUN flutter config --enable-web

# Get dependencies
RUN flutter pub get

# Build Flutter Web app
RUN flutter build web --release

# --- Runtime container ---
FROM node:18-alpine

WORKDIR /app

# Copy built Flutter web files from build stage
COPY --from=build /app/build/web .

# Install static file server
RUN npm install -g serve

EXPOSE 8080
CMD ["serve", "-s", ".", "-l", "8080"]
