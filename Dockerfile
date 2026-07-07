# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:032e035e2366e303cdc2f18a3654588feb5477e099a1f88f996a27a1d01fb81b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:032e035e2366e303cdc2f18a3654588feb5477e099a1f88f996a27a1d01fb81b as release

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
