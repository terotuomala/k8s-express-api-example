# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:f771505c29d1f766c1dc4d3b2ed0f8660a76553685b9d886728bc55d6f430ce8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:f771505c29d1f766c1dc4d3b2ed0f8660a76553685b9d886728bc55d6f430ce8 as release

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
