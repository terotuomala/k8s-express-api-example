FROM node:18-slim@sha256:40e3b696ef30fdd8010a0090d32c244a2b365f0425f1a698274db85b85219919 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:40e3b696ef30fdd8010a0090d32c244a2b365f0425f1a698274db85b85219919 as release

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
