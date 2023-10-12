FROM node:20-slim@sha256:a80281b1e5853e3f65696b5a58ac896be5ea510551701e15c3f8e006557e5d30 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:a80281b1e5853e3f65696b5a58ac896be5ea510551701e15c3f8e006557e5d30 as release

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
