# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:22ff8fd1dd7754346b492e4d9feeee8afd5a9bbea3f233d6217339f5d3bdf270 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:22ff8fd1dd7754346b492e4d9feeee8afd5a9bbea3f233d6217339f5d3bdf270 as release

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
