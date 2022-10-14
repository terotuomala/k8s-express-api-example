FROM node:18-slim@sha256:f19a9bfe36e66bff93489402385aa4f1024c493ad79fb199eb83ed019f787b47 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:f19a9bfe36e66bff93489402385aa4f1024c493ad79fb199eb83ed019f787b47 as release

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
