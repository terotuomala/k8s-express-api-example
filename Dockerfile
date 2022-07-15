FROM node:18-slim@sha256:dc51bdd082f355574f0c534ffa1c0d5fcdb825ed673da6486ecd566091b8d8f0 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:dc51bdd082f355574f0c534ffa1c0d5fcdb825ed673da6486ecd566091b8d8f0 as release

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
