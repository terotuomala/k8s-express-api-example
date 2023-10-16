FROM node:20-slim@sha256:38d2e7aae7242740f726f72104e4039b7c5a9ae62f337988a68a8f04616df0b7 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:38d2e7aae7242740f726f72104e4039b7c5a9ae62f337988a68a8f04616df0b7 as release

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
