# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:6ca7f7a3b1ae0a24009bb3d90289fde401bde96313add9963e2a53274a614d38 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:6ca7f7a3b1ae0a24009bb3d90289fde401bde96313add9963e2a53274a614d38 as release

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
