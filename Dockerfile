FROM node:18-slim@sha256:3a83bba6aff12b9c2966155b0e3e342302f3763406f5562605f560ee1cd7225b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:3a83bba6aff12b9c2966155b0e3e342302f3763406f5562605f560ee1cd7225b as release

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
