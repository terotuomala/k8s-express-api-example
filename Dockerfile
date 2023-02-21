FROM node:19-slim@sha256:e684615bdfb71cb676b3d0dfcc538c416f7254697d8f9639bd87255062fd1681 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:e684615bdfb71cb676b3d0dfcc538c416f7254697d8f9639bd87255062fd1681 as release

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
