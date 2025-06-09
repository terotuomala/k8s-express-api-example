# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:bdb3ccdc9a6bacfe6c68724d6a5e979f5cfe264a67cb2a1fcdbd199c6bdac424 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:bdb3ccdc9a6bacfe6c68724d6a5e979f5cfe264a67cb2a1fcdbd199c6bdac424 as release

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
