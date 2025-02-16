# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:ebcacf5a59abc7e5f06a5be7890eee41f4db116bc8b7eb1e343306145f57d4b0 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:ebcacf5a59abc7e5f06a5be7890eee41f4db116bc8b7eb1e343306145f57d4b0 as release

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
