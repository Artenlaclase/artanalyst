FROM dart:stable AS build

WORKDIR /app
COPY packages/shared packages/shared
COPY packages/server/licensing packages/server/licensing

WORKDIR /app/packages/server/licensing
RUN dart pub get --offline || dart pub get
RUN dart compile exe bin/server.dart -o bin/server

FROM subfuzion/dart:slim
COPY --from=build /app/packages/server/licensing/bin/server /app/bin/server

EXPOSE 8081
CMD ["/app/bin/server"]
