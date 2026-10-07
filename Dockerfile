# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:4dcf9bbb401b4ba7e1fb65dcc5dbd42d71bac515ed6a4662126424017d51df8e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:4dcf9bbb401b4ba7e1fb65dcc5dbd42d71bac515ed6a4662126424017d51df8e as release

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
