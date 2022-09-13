FROM node:18-slim@sha256:d415eea4eb02c933213cee0a591ff2198a92abc3941c46bbcd1364290cbdb92b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:d415eea4eb02c933213cee0a591ff2198a92abc3941c46bbcd1364290cbdb92b as release

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
