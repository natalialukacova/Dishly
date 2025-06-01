# Flutter Web Builder Image
FROM ghcr.io/cirruslabs/flutter:stable-web AS build

WORKDIR /app

# Copy entire Flutter project
COPY . .

RUN flutter pub get
RUN flutter build web --release

# --- Runtime container ---
FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/build/web .

RUN npm install -g serve

EXPOSE 8080
CMD ["serve", "-s", ".", "-l", "8080"]
