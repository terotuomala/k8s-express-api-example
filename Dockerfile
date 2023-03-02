FROM node:19-slim@sha256:424dd181b3be2a7aec23f6ba3b69e732745bad42e9b8a473efcb1399e76f12de as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:424dd181b3be2a7aec23f6ba3b69e732745bad42e9b8a473efcb1399e76f12de as release

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
