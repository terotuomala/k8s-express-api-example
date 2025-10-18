# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:2e21aaf5d2d0040fe9c78ef6563ed4775a049c928f83d20252115b660db8a977 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:2e21aaf5d2d0040fe9c78ef6563ed4775a049c928f83d20252115b660db8a977 as release

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
