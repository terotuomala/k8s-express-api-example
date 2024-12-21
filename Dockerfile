# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:180222189675638e6732eff3fdd825d1600b79a17eebd6e9de9cb2a1ddda965d as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:180222189675638e6732eff3fdd825d1600b79a17eebd6e9de9cb2a1ddda965d as release

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
