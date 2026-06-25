# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:955b52dd59f8a73419fe1931e13a9b9eb822e7e5fda21ca754688b55753ea6ca as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:955b52dd59f8a73419fe1931e13a9b9eb822e7e5fda21ca754688b55753ea6ca as release

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
