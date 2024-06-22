# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:c878b0a75329bbab90f6e0a4b62baf730401c5ece0276f6ae3560f6c3e988843 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:c878b0a75329bbab90f6e0a4b62baf730401c5ece0276f6ae3560f6c3e988843 as release

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
