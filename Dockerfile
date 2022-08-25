FROM node:18-slim@sha256:12b15efcc41e137ca24d9a13acade91f67c8da3729be8af48dd1dd089d0046ce as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:12b15efcc41e137ca24d9a13acade91f67c8da3729be8af48dd1dd089d0046ce as release

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
