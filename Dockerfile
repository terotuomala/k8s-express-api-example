# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:fe7b5c68d9d693acf191ef39f2e71b7c09c2f9474cc2a72a97ed09fd473c2743 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:fe7b5c68d9d693acf191ef39f2e71b7c09c2f9474cc2a72a97ed09fd473c2743 as release

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
