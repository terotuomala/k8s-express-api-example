# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:80faa9c83200db7eb0c5d4905b8e2f28a0abe64d873465d21940a8c3dfb0fa8b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:80faa9c83200db7eb0c5d4905b8e2f28a0abe64d873465d21940a8c3dfb0fa8b as release

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
