FROM node:alpine AS build

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

RUN yarn build

FROM node:alpine

WORKDIR /app
COPY --from=build /app /app

RUN yarn global add serve

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3000

ENTRYPOINT [ "serve", "-s", "build" ]