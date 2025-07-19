# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:bdf4392ef957016487dea5e10c5226f13e7bdcd0eded6113621852190453ac8b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:bdf4392ef957016487dea5e10c5226f13e7bdcd0eded6113621852190453ac8b as release

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
