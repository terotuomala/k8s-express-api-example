FROM node:19-slim@sha256:602626a95fde52072639a61a3bb6dad86aea5d6776687788f707d6bc2c6e0b87 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:602626a95fde52072639a61a3bb6dad86aea5d6776687788f707d6bc2c6e0b87 as release

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
