# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:d15c133f27f390e6789a529f6e41587e2189994e054e6a36a7c5baaecc84ff36 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:d15c133f27f390e6789a529f6e41587e2189994e054e6a36a7c5baaecc84ff36 as release

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
