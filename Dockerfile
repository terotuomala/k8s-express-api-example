# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:9e500d12926bd0fa15af2d1f7f7a74c33ae812514d32d5d24624144ade6c1701 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:9e500d12926bd0fa15af2d1f7f7a74c33ae812514d32d5d24624144ade6c1701 as release

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
