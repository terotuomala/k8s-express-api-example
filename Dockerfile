FROM node:21-slim@sha256:8d66ff8ac7f7053d707de87bc86ebfe8b4052e4fc8a9d3195e8f8441a247bd70 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:8d66ff8ac7f7053d707de87bc86ebfe8b4052e4fc8a9d3195e8f8441a247bd70 as release

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
