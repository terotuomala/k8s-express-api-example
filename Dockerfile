# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:e2415eee617a78851803a31f8cff2c5164283843855573b4b4a591a93fc5c5b7 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:e2415eee617a78851803a31f8cff2c5164283843855573b4b4a591a93fc5c5b7 as release

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
