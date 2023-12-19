FROM node:21-slim@sha256:6233b0e9257da6a7df6aed5d726625735b70f0ef1f77b23fc462b8020d1056b9 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:6233b0e9257da6a7df6aed5d726625735b70f0ef1f77b23fc462b8020d1056b9 as release

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
