# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:6b02b9b489f4246e507e2b8d9890238d3a2a0b8368da9191546d9e2bebe1bd7e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:6b02b9b489f4246e507e2b8d9890238d3a2a0b8368da9191546d9e2bebe1bd7e as release

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
