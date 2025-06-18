# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5e85ef0c0868d8b686f405b5b09482433e890cfd0651a9f2f47ccdafdf1bb4cd as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5e85ef0c0868d8b686f405b5b09482433e890cfd0651a9f2f47ccdafdf1bb4cd as release

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
