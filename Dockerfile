# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:857cb86c746a3d202fdc0cbebb67fb22b3bf51890c0f3ee6af6b40be2059c725 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:857cb86c746a3d202fdc0cbebb67fb22b3bf51890c0f3ee6af6b40be2059c725 as release

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
