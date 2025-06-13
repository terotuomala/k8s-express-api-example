# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:0d234a5a22ead53f02f3f7cd6fa7ef04a10eeda703c3110700e9686c477bfa1e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:0d234a5a22ead53f02f3f7cd6fa7ef04a10eeda703c3110700e9686c477bfa1e as release

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
