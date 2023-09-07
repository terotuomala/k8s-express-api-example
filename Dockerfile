FROM node:20-slim@sha256:e1eb4a77df4da741c10c17497cec32898692d849d4b4c5a7d214b13604b9fa7d as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:e1eb4a77df4da741c10c17497cec32898692d849d4b4c5a7d214b13604b9fa7d as release

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
