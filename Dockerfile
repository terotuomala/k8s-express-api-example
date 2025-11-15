# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:b76316a6e6544a99541524d3ff5b491daa09ea4f623746cbb9f6930b98a1ccbc as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:b76316a6e6544a99541524d3ff5b491daa09ea4f623746cbb9f6930b98a1ccbc as release

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
