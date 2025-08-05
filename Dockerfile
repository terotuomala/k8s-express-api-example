# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:3ad18a6f93dc34699f52e9c315981bae8b477c80897f645a9fe3b9272c78f54b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:3ad18a6f93dc34699f52e9c315981bae8b477c80897f645a9fe3b9272c78f54b as release

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
