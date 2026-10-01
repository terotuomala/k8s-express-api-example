# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:85dc5b72e071fd1cae9cefea43e0becd985352e2b2514af66b7d37f00b450649 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:85dc5b72e071fd1cae9cefea43e0becd985352e2b2514af66b7d37f00b450649 as release

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
