# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:1048f117c9e48b2b1c5042d76f6fed69438baf8ea34e5d14f4bc4774fdb190de as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:1048f117c9e48b2b1c5042d76f6fed69438baf8ea34e5d14f4bc4774fdb190de as release

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
