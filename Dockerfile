# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:e2852e60448ce03d9021c638c56a1db239244ad3b4c5ffd7c828a2ce288aa226 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:e2852e60448ce03d9021c638c56a1db239244ad3b4c5ffd7c828a2ce288aa226 as release

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
