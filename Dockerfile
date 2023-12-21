FROM node:21-slim@sha256:c88704924204ee6d4e9da02275a8fd27355502f7177e4175cd0d3a4375a9c9c8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:c88704924204ee6d4e9da02275a8fd27355502f7177e4175cd0d3a4375a9c9c8 as release

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
