FROM node:20-slim@sha256:2dab2d0e8813ee1601f8d25a8e4aa5530ffc4d0cc16600ec4fd080263b5b1ccd as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:2dab2d0e8813ee1601f8d25a8e4aa5530ffc4d0cc16600ec4fd080263b5b1ccd as release

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
