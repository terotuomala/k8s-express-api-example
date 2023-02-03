FROM node:19-slim@sha256:e75a12d97ee874d93f44b99120ac6c2fc19256edfbb285195946ce7b120a798b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:e75a12d97ee874d93f44b99120ac6c2fc19256edfbb285195946ce7b120a798b as release

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
