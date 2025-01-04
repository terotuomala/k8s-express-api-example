# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:46a5770d4b5a4a6ebf2565c722a2bd884b9b6158ffdfe2e726de4c74f2ba272f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:46a5770d4b5a4a6ebf2565c722a2bd884b9b6158ffdfe2e726de4c74f2ba272f as release

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
