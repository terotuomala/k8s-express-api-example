FROM node:18-slim@sha256:1d19200eb8291351a8f917f1b7d4401cff58cfabed5102a2333bc1c3b77ec314 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:1d19200eb8291351a8f917f1b7d4401cff58cfabed5102a2333bc1c3b77ec314 as release

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
