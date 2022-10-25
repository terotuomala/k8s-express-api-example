FROM node:19-slim@sha256:f87456d191c00b6f3fa58e61ba8fc93bbad8bd4a08f3cc04051d8083a090c6d2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:f87456d191c00b6f3fa58e61ba8fc93bbad8bd4a08f3cc04051d8083a090c6d2 as release

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
