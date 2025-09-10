# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:99ad189aacd1c477f1e62e2e55b6e1e4de8062d5986d38beb685be0af99281df as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:99ad189aacd1c477f1e62e2e55b6e1e4de8062d5986d38beb685be0af99281df as release

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
