FROM node:19-slim@sha256:fe9b9561c21d74c0a3c49e3ff2e77322343bba2647d85758f302fe54bc4f47da as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:fe9b9561c21d74c0a3c49e3ff2e77322343bba2647d85758f302fe54bc4f47da as release

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
