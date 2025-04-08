# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5dd9a21470192c173e7b87a891edf3a0fb97f39e60fc7b2c10fc61d6f61a0f65 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5dd9a21470192c173e7b87a891edf3a0fb97f39e60fc7b2c10fc61d6f61a0f65 as release

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
