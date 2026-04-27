# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5c70d8c00fc9db841895c06896308b316ad0f9e073e7f3e0608c316310d0687b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5c70d8c00fc9db841895c06896308b316ad0f9e073e7f3e0608c316310d0687b as release

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
