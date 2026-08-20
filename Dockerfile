# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:3a3fbc052438535cca1ac0eed75c2dabf04a7ce7de749667cd265f98dbf9c771 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:3a3fbc052438535cca1ac0eed75c2dabf04a7ce7de749667cd265f98dbf9c771 as release

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
