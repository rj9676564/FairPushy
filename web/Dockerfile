FROM ghcr.io/cirruslabs/flutter:3.41.7 AS build

WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web

FROM nginx:1.27-alpine

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
