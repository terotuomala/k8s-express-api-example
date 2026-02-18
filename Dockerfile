# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:6c859d810a8d433ff2137a54a99296fb9ece473c9607c9514f3179dc691bfcfa as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:6c859d810a8d433ff2137a54a99296fb9ece473c9607c9514f3179dc691bfcfa as release

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
