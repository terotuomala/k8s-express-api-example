# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:dc815e3ebbb81c5099f6229dffeda1c43dab6bbabb6b185908fc626f17e31a4e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:dc815e3ebbb81c5099f6229dffeda1c43dab6bbabb6b185908fc626f17e31a4e as release

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
