# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:f23c515d1c69f53c95feff00c43d69f4d87811dd3aa5c36dd0be1ec5e05571f0 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:f23c515d1c69f53c95feff00c43d69f4d87811dd3aa5c36dd0be1ec5e05571f0 as release

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
