# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:5b7639a6f019d13dbe482e95353de5f2d84bb4cc6222ffe4bf90ab3366b5d338 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:5b7639a6f019d13dbe482e95353de5f2d84bb4cc6222ffe4bf90ab3366b5d338 as release

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
