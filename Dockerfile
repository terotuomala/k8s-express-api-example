FROM node:20-slim@sha256:3a6fe61a331a31dd997016159374b8f398e8e7c5299b5f0ac7fd48c23e34ab5e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:3a6fe61a331a31dd997016159374b8f398e8e7c5299b5f0ac7fd48c23e34ab5e as release

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
