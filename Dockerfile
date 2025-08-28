# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:6fc7161070c46b0a4051f26edc1a3fbe584a143bdc63f77d7b519219b6047cc1 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:6fc7161070c46b0a4051f26edc1a3fbe584a143bdc63f77d7b519219b6047cc1 as release

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
