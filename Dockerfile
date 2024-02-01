FROM node:21-slim@sha256:0ca0e0a19f5818ab2b716772d21c751881cd525362cba428df5a51a75520f7d5 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:0ca0e0a19f5818ab2b716772d21c751881cd525362cba428df5a51a75520f7d5 as release

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
