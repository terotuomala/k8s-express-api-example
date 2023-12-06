FROM node:21-slim@sha256:3a3b69c7013ac1233d4570f14108572e3f6dac3e2cefa8ef63be2885f702d033 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:3a3b69c7013ac1233d4570f14108572e3f6dac3e2cefa8ef63be2885f702d033 as release

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
