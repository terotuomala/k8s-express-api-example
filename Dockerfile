FROM node:21-slim@sha256:0d03aaff72f2cd87a243f1e4b07a9f5267423baec72318cc1ffdb155ff7c2eb2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:0d03aaff72f2cd87a243f1e4b07a9f5267423baec72318cc1ffdb155ff7c2eb2 as release

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
