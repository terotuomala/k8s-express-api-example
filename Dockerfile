FROM node:20-slim@sha256:75404fc5825f24222276501c09944a5bee8ed04517dede5a9934f1654ca84caf as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:75404fc5825f24222276501c09944a5bee8ed04517dede5a9934f1654ca84caf as release

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
