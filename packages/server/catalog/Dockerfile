FROM dart:stable AS build

WORKDIR /app
COPY packages/shared packages/shared
COPY packages/server/catalog packages/server/catalog

WORKDIR /app/packages/server/catalog
RUN dart pub get --offline || dart pub get
RUN dart compile exe bin/server.dart -o bin/server

FROM subfuzion/dart:slim
COPY --from=build /app/packages/server/catalog/bin/server /app/bin/server

EXPOSE 8080
CMD ["/app/bin/server"]
