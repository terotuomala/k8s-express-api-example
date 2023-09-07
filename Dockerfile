FROM node:20-slim@sha256:d33d18494fcfb1bb9759c6b9c28dcfb2a0dd489864b8d41a5d810b73f1f76fc4 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:20-slim@sha256:d33d18494fcfb1bb9759c6b9c28dcfb2a0dd489864b8d41a5d810b73f1f76fc4 as release

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
