# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:b1dba5a3ed153d3cee47b5306e9560eda79983fb11cb35b8c0d7d1bae2360398 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:b1dba5a3ed153d3cee47b5306e9560eda79983fb11cb35b8c0d7d1bae2360398 as release

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
