FROM node:20-slim@sha256:c7060b8f3293caebff96c0d041d3ae903643e89c967bab3b10d4d2f185e816a9 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:c7060b8f3293caebff96c0d041d3ae903643e89c967bab3b10d4d2f185e816a9 as release

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
