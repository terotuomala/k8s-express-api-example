# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:d9238e6b5989a4a80ea19e9751c1e139217a4ad6ee7023e0b4988871e2c2e333 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:d9238e6b5989a4a80ea19e9751c1e139217a4ad6ee7023e0b4988871e2c2e333 as release

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
