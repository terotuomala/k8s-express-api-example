# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:10be2e69be84a55739a6f4e0ab47703746e546006dad2c80494fafc7f5f6c5fd as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:10be2e69be84a55739a6f4e0ab47703746e546006dad2c80494fafc7f5f6c5fd as release

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
