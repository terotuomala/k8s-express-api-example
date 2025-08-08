# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:d96217320e0e3b2d44a0e24ae1d84cff79415c2ee0a45dc1e2da61753c7af311 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:d96217320e0e3b2d44a0e24ae1d84cff79415c2ee0a45dc1e2da61753c7af311 as release

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
