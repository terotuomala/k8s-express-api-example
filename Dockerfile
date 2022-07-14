FROM node:18-slim@sha256:85f3bebc533d681260e78800bfa67a23531abc7dd99fa085d082a81b89d63f91 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:85f3bebc533d681260e78800bfa67a23531abc7dd99fa085d082a81b89d63f91 as release

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
