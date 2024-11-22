# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5141421b48090a9ed4875473000b58d3bde43082da7c3343be9edf6883d80baa as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5141421b48090a9ed4875473000b58d3bde43082da7c3343be9edf6883d80baa as release

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
