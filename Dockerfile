# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:57c1aac4ad38532cabee8bc991286b61cb0e4dab26f6e196e5cc8f042a25dd15 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:57c1aac4ad38532cabee8bc991286b61cb0e4dab26f6e196e5cc8f042a25dd15 as release

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
