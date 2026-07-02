# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5280e63c3d2c81366056926b79f27f70e4adbd3a03a5b45c53503eac2b722b3f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5280e63c3d2c81366056926b79f27f70e4adbd3a03a5b45c53503eac2b722b3f as release

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
