FROM node:20-slim@sha256:1336bbff672c56537c0ab7268b6ca3a62ee7ce702860beb74a9f52ce25571769 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:1336bbff672c56537c0ab7268b6ca3a62ee7ce702860beb74a9f52ce25571769 as release

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
