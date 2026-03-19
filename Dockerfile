# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:323bf27b0c5d19d8a4d2d195a215b1389ebe481f32d211dc0f1a9d982e38b086 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:323bf27b0c5d19d8a4d2d195a215b1389ebe481f32d211dc0f1a9d982e38b086 as release

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
