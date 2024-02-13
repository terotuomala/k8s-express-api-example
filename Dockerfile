FROM node:21-slim@sha256:6b35c9b34836d7d4a686d8a899cb503533040d43d8cb0dcb51ef832108573a86 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:6b35c9b34836d7d4a686d8a899cb503533040d43d8cb0dcb51ef832108573a86 as release

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
