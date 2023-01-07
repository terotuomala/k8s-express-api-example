FROM node:19-slim@sha256:945442de04fb2ed3917e3e43f86cf44286db0f9d472ef011f63a191cd2fbae93 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:945442de04fb2ed3917e3e43f86cf44286db0f9d472ef011f63a191cd2fbae93 as release

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
