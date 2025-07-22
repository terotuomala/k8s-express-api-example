# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:001dc716a5c2e36122cf6426e3afb006927d18a44a69532db2d65b14cfb6fe9f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:001dc716a5c2e36122cf6426e3afb006927d18a44a69532db2d65b14cfb6fe9f as release

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
