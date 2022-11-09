FROM node:19-slim@sha256:c50fa1ec635d2e2523490b968f15422982c50713c8d05c7cdb109a3f6fdd4d7c as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:c50fa1ec635d2e2523490b968f15422982c50713c8d05c7cdb109a3f6fdd4d7c as release

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
