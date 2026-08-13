# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:71102c411350b53ff67f83c6679070a6c839306d84f9033146f8b93b0d730c78 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:71102c411350b53ff67f83c6679070a6c839306d84f9033146f8b93b0d730c78 as release

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
