FROM node:18-slim@sha256:e3c7927b7ac85e49d406ed3db8f49547c870f3dfbf409b3620cbbd927177ef80 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:e3c7927b7ac85e49d406ed3db8f49547c870f3dfbf409b3620cbbd927177ef80 as release

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
