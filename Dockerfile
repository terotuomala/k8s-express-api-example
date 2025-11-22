# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:92868f7456f6f2d00bfe04601bf76e52c3e9c91125686f0d2f0107ba20ea7bb4 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:92868f7456f6f2d00bfe04601bf76e52c3e9c91125686f0d2f0107ba20ea7bb4 as release

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
