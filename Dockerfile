# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:f193473f86d19bb32ce5242fb515577b656c6177794fd5a6189cc1ccd5122f0d as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:f193473f86d19bb32ce5242fb515577b656c6177794fd5a6189cc1ccd5122f0d as release

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
