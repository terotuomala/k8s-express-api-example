# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:2e4f979d1e05d89c41d7f59028fb72c61267413caf50b14a02eafa4ab11c8b5b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:2e4f979d1e05d89c41d7f59028fb72c61267413caf50b14a02eafa4ab11c8b5b as release

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
