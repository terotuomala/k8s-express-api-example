# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:7980499c2e97ac95b884b78f3e11328ca526e9a3a56e42d8dbd8ab3a6a72d6c0 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:7980499c2e97ac95b884b78f3e11328ca526e9a3a56e42d8dbd8ab3a6a72d6c0 as release

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
