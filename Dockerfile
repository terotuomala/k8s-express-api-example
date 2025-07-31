# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:be18e51827d1104f457260f559d463c5200290d6d1c492ba999a7578bed3525a as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:be18e51827d1104f457260f559d463c5200290d6d1c492ba999a7578bed3525a as release

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
