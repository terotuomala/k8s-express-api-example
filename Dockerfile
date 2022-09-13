FROM node:18-slim@sha256:025173d7ce52ce7db9c8c171735b7903be21ddecf93fae4161137c87e710c145 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:025173d7ce52ce7db9c8c171735b7903be21ddecf93fae4161137c87e710c145 as release

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
