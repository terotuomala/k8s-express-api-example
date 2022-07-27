FROM node:18-slim@sha256:d6cfad24f64d1587a7878d03e23b157c17f2a66b617d79bb9890924f6e851d2f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:d6cfad24f64d1587a7878d03e23b157c17f2a66b617d79bb9890924f6e851d2f as release

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
