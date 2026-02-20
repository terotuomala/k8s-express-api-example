# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:e30593ef2eb6736f4ba95ad6dd8da1dbcd58518d0ca01ba2eb34a34cf9c43464 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:e30593ef2eb6736f4ba95ad6dd8da1dbcd58518d0ca01ba2eb34a34cf9c43464 as release

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
