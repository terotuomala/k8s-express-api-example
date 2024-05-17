# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:f00e6f8cdc8851e087aae290125b042a1cd2d8cafc3e16b238d68254dca34d73 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:f00e6f8cdc8851e087aae290125b042a1cd2d8cafc3e16b238d68254dca34d73 as release

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
