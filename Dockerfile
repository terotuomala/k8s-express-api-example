# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:7e1dbf0b0f81742194929afb2aac27802558e0026a2e86283a82ac962bb6cf9d as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:7e1dbf0b0f81742194929afb2aac27802558e0026a2e86283a82ac962bb6cf9d as release

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
