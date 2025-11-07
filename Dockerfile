# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:35248c86e91cdfa3db0d5d65e5fae9efa7950f4576bb9dc5cbce9e422d2072b8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:35248c86e91cdfa3db0d5d65e5fae9efa7950f4576bb9dc5cbce9e422d2072b8 as release

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
