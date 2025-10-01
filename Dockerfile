# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:fadae955af4116ea4cd6bc0f069d7157d9d75ff4b681ebc2748b2c1a87c3e205 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:fadae955af4116ea4cd6bc0f069d7157d9d75ff4b681ebc2748b2c1a87c3e205 as release

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
