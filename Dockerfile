# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:e16cfb81ff7fc587e1e293526593757f55d6a76cd5bf6c7eab69905b0f4dc942 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:e16cfb81ff7fc587e1e293526593757f55d6a76cd5bf6c7eab69905b0f4dc942 as release

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
