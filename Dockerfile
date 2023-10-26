FROM node:21-slim@sha256:d1144205c1f72a9788d42ba0b899a9fa26fc5e2d87993084b7ed1b59da5ea7b7 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:d1144205c1f72a9788d42ba0b899a9fa26fc5e2d87993084b7ed1b59da5ea7b7 as release

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
