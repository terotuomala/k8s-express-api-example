# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:7d7ae95203d0855c201c0166535d7450185f9ea07c35ef6d3ffe2b5c473bd49e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:7d7ae95203d0855c201c0166535d7450185f9ea07c35ef6d3ffe2b5c473bd49e as release

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
