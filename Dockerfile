# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:f819ce9bc54ff2a771a6849ec8453aaab9bb697873f3f6b91039ed07a3626748 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:f819ce9bc54ff2a771a6849ec8453aaab9bb697873f3f6b91039ed07a3626748 as release

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
