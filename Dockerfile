FROM node:19-slim@sha256:9a8592fdcc928c211a033d3a416207e13419361a3b9316dbcab4e01581fc00e4 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:9a8592fdcc928c211a033d3a416207e13419361a3b9316dbcab4e01581fc00e4 as release

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
