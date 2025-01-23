# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:4a4a7df87bca987061d2b8c2c1b92ab53dd08c5acf1735e8e3346e4bba625fef as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:4a4a7df87bca987061d2b8c2c1b92ab53dd08c5acf1735e8e3346e4bba625fef as release

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
