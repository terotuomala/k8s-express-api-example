FROM node:19-slim@sha256:d6f1d4b0ba2b51f1ea448a27ae31f499ddfcef60cc51f899264a8e8be22e2d0b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:d6f1d4b0ba2b51f1ea448a27ae31f499ddfcef60cc51f899264a8e8be22e2d0b as release

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
