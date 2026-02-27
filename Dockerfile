# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:0b1d1e18e9c1d33da111a47492219b47b4932c79d09cc666e04a83b91c81c826 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:0b1d1e18e9c1d33da111a47492219b47b4932c79d09cc666e04a83b91c81c826 as release

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
