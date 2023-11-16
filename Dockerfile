FROM node:21-slim@sha256:a38a2cc10d64169939a77c31dd514c0a679ced58455c2c020be7f6d2b0388fd8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:a38a2cc10d64169939a77c31dd514c0a679ced58455c2c020be7f6d2b0388fd8 as release

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
