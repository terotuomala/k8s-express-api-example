FROM node:21-slim@sha256:9df21707e27d98ee83e079fa47c5c0c5fba6c768e566643f8944b00b00afc4a2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:9df21707e27d98ee83e079fa47c5c0c5fba6c768e566643f8944b00b00afc4a2 as release

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
