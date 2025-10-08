# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:47adb16f994ab8fc0eeb0ace9efb8b93edc9c4d0a6842f8fd31d3b2daea483e1 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:47adb16f994ab8fc0eeb0ace9efb8b93edc9c4d0a6842f8fd31d3b2daea483e1 as release

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
