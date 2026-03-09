# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:99dc9c014d0d53635389a114f053c4e03385148678c1fca2fac413933c2fad5f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:99dc9c014d0d53635389a114f053c4e03385148678c1fca2fac413933c2fad5f as release

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
