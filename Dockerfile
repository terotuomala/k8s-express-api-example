# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:8828c6e74c782babb020e684f026a7747d91a0699e7f2a2163f905c47f65e4da as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:8828c6e74c782babb020e684f026a7747d91a0699e7f2a2163f905c47f65e4da as release

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
