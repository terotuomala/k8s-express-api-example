# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:59a7875b6a4b5a2b6f2c2ae8bae580405f7b39f733be323084a38ded3a662534 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:59a7875b6a4b5a2b6f2c2ae8bae580405f7b39f733be323084a38ded3a662534 as release

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
