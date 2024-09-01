# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:723a424ce87314a7393c838860358a1d2d170f842d23eb4b6e427b06f6fb12f8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:723a424ce87314a7393c838860358a1d2d170f842d23eb4b6e427b06f6fb12f8 as release

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
