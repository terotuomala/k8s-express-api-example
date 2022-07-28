FROM node:18-slim@sha256:bf8977f82b0353a05309d5581e1b6652e5e282a3b35333d6c40d3732d99e558f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:bf8977f82b0353a05309d5581e1b6652e5e282a3b35333d6c40d3732d99e558f as release

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
