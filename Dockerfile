# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:10e6e1c8489d318f40c6b79c8ad64dc3a53ec3f2c14657a9a0310259eb681e52 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:10e6e1c8489d318f40c6b79c8ad64dc3a53ec3f2c14657a9a0310259eb681e52 as release

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
