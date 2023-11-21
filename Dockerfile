FROM node:21-slim@sha256:9cbf7eced7de09dcc8d0bd159232c52b64de722ce5f3d219753e6b426e9ce5ea as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:9cbf7eced7de09dcc8d0bd159232c52b64de722ce5f3d219753e6b426e9ce5ea as release

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
