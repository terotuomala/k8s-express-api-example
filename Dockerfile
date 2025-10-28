# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:a5bf03094875904f118dba28da5b6c1d0ebc665fb3bc6f3deb32b420bf2712b3 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:a5bf03094875904f118dba28da5b6c1d0ebc665fb3bc6f3deb32b420bf2712b3 as release

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
