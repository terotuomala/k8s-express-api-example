# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:2d203e8423b74494871a218cf7c31a15a872c10626b541599097431e16d7b4ce as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:2d203e8423b74494871a218cf7c31a15a872c10626b541599097431e16d7b4ce as release

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
