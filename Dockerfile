# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:cf7ae5ead5aed79a61404d7b1bbb9b89ea461991b21cb8fcb07d4b6ad4d8b734 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:cf7ae5ead5aed79a61404d7b1bbb9b89ea461991b21cb8fcb07d4b6ad4d8b734 as release

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
