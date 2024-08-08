# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:2c53418bc78e72fe4be07b110f36633035250f4ed674a81af291625c3d46aaae as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:2c53418bc78e72fe4be07b110f36633035250f4ed674a81af291625c3d46aaae as release

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
