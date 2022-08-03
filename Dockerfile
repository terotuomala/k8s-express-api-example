FROM node:18-slim@sha256:46f854a8f54b0460702602f45eca29aecc4c39135056e378fa7707a81da3744d as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:46f854a8f54b0460702602f45eca29aecc4c39135056e378fa7707a81da3744d as release

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
