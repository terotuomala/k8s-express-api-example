FROM node:21-slim@sha256:d966b29a93ad2c369b4d97c5442b2527f75b5494783b1d84b18a030540421790 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:d966b29a93ad2c369b4d97c5442b2527f75b5494783b1d84b18a030540421790 as release

# Switch to non-root user uid=1000(node)
USER node

# Set environment variables
ENV NPM_CONFIG_LOGLEVEL=warn
ENV NODE_ENV=production

# Change working directory
WORKDIR /home/node

# Copy app directory from build stage
COPY --chown=node:node --from=build /app .

EXPOSE 3001

CMD ["node", "src/index.js"]
