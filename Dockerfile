# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:d1af9eb3a1eab9d23c9f1d987313c1fd2444d8bdcbe283f4c6a69a93568c6fd5 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:d1af9eb3a1eab9d23c9f1d987313c1fd2444d8bdcbe283f4c6a69a93568c6fd5 as release

# Switch to non-root user uid=65532(node)
USER node

# Set environment variables
ENV NPM_CONFIG_LOGLEVEL=warn
ENV NODE_ENV=production

# Change working directory
WORKDIR /app

# Copy app directory from build stage
COPY --link --chown=65532 --from=build /app .

EXPOSE 3001

CMD ["src/index.js"]
