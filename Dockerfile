# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:dc6e1253d18433294d67c76bc3eafa41177f3eed1272d0b89d2ca6154693aadc as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:dc6e1253d18433294d67c76bc3eafa41177f3eed1272d0b89d2ca6154693aadc as release

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
