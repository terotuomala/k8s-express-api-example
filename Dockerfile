FROM node:18-slim@sha256:6b6c5fbcba9d33ccbcdcda670f1fe37685d6e990a538eec30a66f8c4b6191bf2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:6b6c5fbcba9d33ccbcdcda670f1fe37685d6e990a538eec30a66f8c4b6191bf2 as release

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
