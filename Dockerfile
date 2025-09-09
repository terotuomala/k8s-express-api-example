# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:c832ff3361be3e7079be773e116cd06de1d1cc984de47c899f0b109ad61e5c7f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:c832ff3361be3e7079be773e116cd06de1d1cc984de47c899f0b109ad61e5c7f as release

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
