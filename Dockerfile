# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:22568f2da241f7bbe75f381a8d110e19376bd380eb41c62695c4c0f80e4c8396 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:22568f2da241f7bbe75f381a8d110e19376bd380eb41c62695c4c0f80e4c8396 as release

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
