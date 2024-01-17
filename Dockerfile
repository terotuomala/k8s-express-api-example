FROM node:21-slim@sha256:e8a7eb273ef8a9ebc03f0ad03c0fd4bbc3562ec244691e6fc37344ee2c4357d2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:e8a7eb273ef8a9ebc03f0ad03c0fd4bbc3562ec244691e6fc37344ee2c4357d2 as release

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
