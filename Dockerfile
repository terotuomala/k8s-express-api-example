FROM node:19-slim@sha256:34211d15e360eff92c17587ff3c3d3bea3061ca3961f745fd59ab30bda954ff9 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:34211d15e360eff92c17587ff3c3d3bea3061ca3961f745fd59ab30bda954ff9 as release

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
