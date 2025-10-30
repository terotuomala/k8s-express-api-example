# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:56f1ce6c79c349f51a356c1a041d9741862858d9c896dfb7f2b1905874571bfc as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:56f1ce6c79c349f51a356c1a041d9741862858d9c896dfb7f2b1905874571bfc as release

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
