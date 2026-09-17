# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:1f903d44fc11a6f6e74447fc2c6a3c141f112217576be5d96c283210116b5d25 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:1f903d44fc11a6f6e74447fc2c6a3c141f112217576be5d96c283210116b5d25 as release

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
