FROM node:21-slim@sha256:bb31faf29df6691af3d7c60d1ad5970ae398bd4bf796a9f6b02a6a3541281458 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:bb31faf29df6691af3d7c60d1ad5970ae398bd4bf796a9f6b02a6a3541281458 as release

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
