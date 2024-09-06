# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:7160e78c6e9dad9a99b6efe986317334600d3de8462d9b624dfc99fad8af536f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:7160e78c6e9dad9a99b6efe986317334600d3de8462d9b624dfc99fad8af536f as release

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
