FROM node:20-slim@sha256:11f66bf5d0842fe1f87457fabe62aa3bbcfbb739d231a39e67597af22d8f5ffd as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:11f66bf5d0842fe1f87457fabe62aa3bbcfbb739d231a39e67597af22d8f5ffd as release

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
