# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:dd63a76ecf5fe918884ab0ba1b8ce5f77299227e575886c279f350efa943f0e9 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:dd63a76ecf5fe918884ab0ba1b8ce5f77299227e575886c279f350efa943f0e9 as release

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
