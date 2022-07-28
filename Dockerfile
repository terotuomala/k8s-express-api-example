FROM node:18-slim@sha256:889e696f80a9fc8a78f01260339e9a91de6fd81d70df4a35d84bf97d3869508f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:889e696f80a9fc8a78f01260339e9a91de6fd81d70df4a35d84bf97d3869508f as release

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
