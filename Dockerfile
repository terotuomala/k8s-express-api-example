# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5d6d6287abf176121b173a0337a888900f2909f0ac06e4e096138be4898a8f92 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5d6d6287abf176121b173a0337a888900f2909f0ac06e4e096138be4898a8f92 as release

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
