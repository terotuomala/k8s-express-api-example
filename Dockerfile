FROM node:19-slim@sha256:05101a5dea391aa93f1bd4347a7b029b72b612d6ca9d1282942f414df7c2efe8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:05101a5dea391aa93f1bd4347a7b029b72b612d6ca9d1282942f414df7c2efe8 as release

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
