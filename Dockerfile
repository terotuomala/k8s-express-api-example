# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:07f72fbc9143e8a2aab545f683a6895c8b2bc92d82fc46528390b92f922bb7b8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:07f72fbc9143e8a2aab545f683a6895c8b2bc92d82fc46528390b92f922bb7b8 as release

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
