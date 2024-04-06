FROM node:21-slim@sha256:2bf48899bbba183a33b362842c9a9832f19c99896159551f9a0420c53ec27522 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:2bf48899bbba183a33b362842c9a9832f19c99896159551f9a0420c53ec27522 as release

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
