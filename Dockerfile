# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:391ab1b467e959a6f09316187ee99cea862c5a579defd98de292475c8440f664 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:391ab1b467e959a6f09316187ee99cea862c5a579defd98de292475c8440f664 as release

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
