# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:c223c6f31e67821219f2c8bcb49cc644871effade1d7284183eb21e747363498 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:c223c6f31e67821219f2c8bcb49cc644871effade1d7284183eb21e747363498 as release

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
