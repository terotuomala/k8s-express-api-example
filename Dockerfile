# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:9b39ee31665469c51b76516cf08d46380797bcd7e8418cb1f16e5fad7b6f6c48 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:9b39ee31665469c51b76516cf08d46380797bcd7e8418cb1f16e5fad7b6f6c48 as release

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
