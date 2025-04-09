# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:bd2eb0d8aee288fb4acae41373b450d234e249d1f7fdb0411e2a3ba16de82a84 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:bd2eb0d8aee288fb4acae41373b450d234e249d1f7fdb0411e2a3ba16de82a84 as release

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
