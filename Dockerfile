# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:9f3222716308473ea3362cf1f4cfb090e37c1f34c64b585c4e7e1e3f0ff0fdda as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:9f3222716308473ea3362cf1f4cfb090e37c1f34c64b585c4e7e1e3f0ff0fdda as release

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
