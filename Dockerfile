# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:4de8f3c2f9f764e7e81f222ee02eba835383b476c89cf398e21769079c21db29 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:4de8f3c2f9f764e7e81f222ee02eba835383b476c89cf398e21769079c21db29 as release

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
