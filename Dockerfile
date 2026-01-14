# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:4c0ecb7ed824dca4a8031fe90810134b63c15e4f4d943cf2845cff4c819c8a85 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:4c0ecb7ed824dca4a8031fe90810134b63c15e4f4d943cf2845cff4c819c8a85 as release

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
