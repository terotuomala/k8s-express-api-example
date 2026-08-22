# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:f2a8ed64ec02cef2e53c76d1255d0917e749570af251e32e99f54cda1076cc8d as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:f2a8ed64ec02cef2e53c76d1255d0917e749570af251e32e99f54cda1076cc8d as release

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
