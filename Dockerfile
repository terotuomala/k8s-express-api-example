# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:75e6c806a4654a59f42b957dcced700a25aa6c47c3fa3cfc37fed3cb9a86e5ac as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:75e6c806a4654a59f42b957dcced700a25aa6c47c3fa3cfc37fed3cb9a86e5ac as release

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
