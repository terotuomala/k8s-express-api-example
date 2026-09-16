# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:e48acd045f3c4da0148a59f5eba5f2ad8067ca8d177debf5522074df0454431c as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:e48acd045f3c4da0148a59f5eba5f2ad8067ca8d177debf5522074df0454431c as release

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
