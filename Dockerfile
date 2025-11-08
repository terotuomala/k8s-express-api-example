# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:63525fac2a4b0a6bd6f8552c948cb0be4d2895d77dba1bec8e4bf6e205a7bca2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:63525fac2a4b0a6bd6f8552c948cb0be4d2895d77dba1bec8e4bf6e205a7bca2 as release

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
