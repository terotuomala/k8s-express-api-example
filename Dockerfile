FROM node:20-slim@sha256:fe600ecd55fa23b90c716d03f05dfcb2c5cfa7ee01eefb1a76a03ba656f92953 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:fe600ecd55fa23b90c716d03f05dfcb2c5cfa7ee01eefb1a76a03ba656f92953 as release

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
