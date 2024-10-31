# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:04a1b598ff86d3a633be3eec11206a63479854ae97f89cd42d9cf1adbc21929f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:04a1b598ff86d3a633be3eec11206a63479854ae97f89cd42d9cf1adbc21929f as release

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
