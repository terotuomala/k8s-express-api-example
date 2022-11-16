FROM node:19-slim@sha256:ea46185af8498b01a0af84e32c8b17933944e2444e1bee7602ef74bf6c758c0a as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:ea46185af8498b01a0af84e32c8b17933944e2444e1bee7602ef74bf6c758c0a as release

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
