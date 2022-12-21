FROM node:19-slim@sha256:087bec6eb54df20e5b09b9f0f36e32a4a484832cf3686e4c3402f6577b851516 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:087bec6eb54df20e5b09b9f0f36e32a4a484832cf3686e4c3402f6577b851516 as release

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
