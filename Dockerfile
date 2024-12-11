# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:f657af3c8969f58caf71dde34ed60d2aadb1161ffb05c63d403b5d283b2c0cc3 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:f657af3c8969f58caf71dde34ed60d2aadb1161ffb05c63d403b5d283b2c0cc3 as release

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
