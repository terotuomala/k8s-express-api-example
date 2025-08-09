# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:db08115fe93217e31691b6b0a2ff495d07f43ca35464182c07a5fa56912a0f6e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:db08115fe93217e31691b6b0a2ff495d07f43ca35464182c07a5fa56912a0f6e as release

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
