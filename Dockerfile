# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:e8a45ba91e4498c23a49175508f725db87c2e4a1178e3573713f781527dea983 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:e8a45ba91e4498c23a49175508f725db87c2e4a1178e3573713f781527dea983 as release

# Switch to non-root user uid=65532(node)
USER node

# Set environment variables
ENV NPM_CONFIG_LOGLEVEL=warn
ENV NODE_ENV=production

# Change working directory
WORKDIR /app

# Copy app directory from build stage
COPY --link --chown=node:node --from=build /app .

EXPOSE 3001

CMD ["src/index.js"]
