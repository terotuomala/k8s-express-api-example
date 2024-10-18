# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:803a8bcf2f8c41870e06ebc2dc4e7558819bf8b2e69961da653a3762ddb2824a as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:803a8bcf2f8c41870e06ebc2dc4e7558819bf8b2e69961da653a3762ddb2824a as release

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
