FROM dart:2.19-sdk AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get
RUN dart compile exe bin/server.dart -o /app/bin/server

FROM debian:bullseye-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

EXPOSE 8080

ENV MYSQL_PORT=3306

CMD ["/app/bin/server"]
