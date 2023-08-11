FROM node:20-slim@sha256:86e9e023e957ba57c2a5d13d0ca978b5019e03eb78cf08a4af8f80abbab23249 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:86e9e023e957ba57c2a5d13d0ca978b5019e03eb78cf08a4af8f80abbab23249 as release

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
