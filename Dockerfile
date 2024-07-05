# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:606e894eed3c1353d30674e50543e4def89e9dcab6a5fd78a6f87986f6df6492 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:606e894eed3c1353d30674e50543e4def89e9dcab6a5fd78a6f87986f6df6492 as release

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
