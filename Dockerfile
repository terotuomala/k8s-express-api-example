FROM node:19-slim@sha256:2dbab7413852fb69e4c0c94815a8c732b5f9a8eb7822840807c43e096b70ea95 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:2dbab7413852fb69e4c0c94815a8c732b5f9a8eb7822840807c43e096b70ea95 as release

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
