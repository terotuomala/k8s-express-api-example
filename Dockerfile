# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:ebd1ed57de167ea250f3b7ab595056f7c9c85b06c5522ca9235dc9cf5542f81e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:ebd1ed57de167ea250f3b7ab595056f7c9c85b06c5522ca9235dc9cf5542f81e as release

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
