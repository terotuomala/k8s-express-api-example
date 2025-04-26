# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:fb6605fb1d6d419e5923570a02fd70665c9349d8f400174d60b86c941824715a as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:fb6605fb1d6d419e5923570a02fd70665c9349d8f400174d60b86c941824715a as release

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
