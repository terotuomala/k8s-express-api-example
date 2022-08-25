FROM node:18-slim@sha256:d65094b7dd5b2f3972bdaca4ef1fc9c4fc63dfa5430fa632955e636345dc42e5 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:d65094b7dd5b2f3972bdaca4ef1fc9c4fc63dfa5430fa632955e636345dc42e5 as release

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
