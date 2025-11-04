# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:1af60f3cf062f7b284e194cf9b8490355e7d6180b17df532356b698fa18b5e98 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:1af60f3cf062f7b284e194cf9b8490355e7d6180b17df532356b698fa18b5e98 as release

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
