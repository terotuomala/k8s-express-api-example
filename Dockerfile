FROM node:19-slim@sha256:d937587325385cd2d38e5d45e9930e7fc6245ba4c23f12c48f6af581fa6d90ac as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:d937587325385cd2d38e5d45e9930e7fc6245ba4c23f12c48f6af581fa6d90ac as release

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
