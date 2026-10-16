# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:2005fde9cb32db51ea3c6b5ab0035f65b4ce0adea3477ed4f5b03297399b74d1 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:2005fde9cb32db51ea3c6b5ab0035f65b4ce0adea3477ed4f5b03297399b74d1 as release

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
