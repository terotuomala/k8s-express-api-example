FROM node:18-slim@sha256:f916ff4bcfc6bbe6e3a4fa24f29109e7446e7bcd1d788066c7c45f705de95e69 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:f916ff4bcfc6bbe6e3a4fa24f29109e7446e7bcd1d788066c7c45f705de95e69 as release

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
