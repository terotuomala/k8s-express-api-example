# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:996e4173ffc282ec4e87d7899c79e25dc36bc72415c29a93381315af07f75bbb as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:996e4173ffc282ec4e87d7899c79e25dc36bc72415c29a93381315af07f75bbb as release

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
