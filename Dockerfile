# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:06f236c66917a695439e5c8ca70298066c141688a7314e9c748424e29edebb1e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:06f236c66917a695439e5c8ca70298066c141688a7314e9c748424e29edebb1e as release

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
