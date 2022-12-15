FROM node:19-slim@sha256:5f80db93d1e5072f646125b51cd5b6ff082e0722462634659243819fb5efdc35 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:5f80db93d1e5072f646125b51cd5b6ff082e0722462634659243819fb5efdc35 as release

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
