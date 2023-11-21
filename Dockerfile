FROM node:21-slim@sha256:2aab47dc57b4cbf889e44ebc1f2a6f698901be6e6be4b558b349a2313b1538c3 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:2aab47dc57b4cbf889e44ebc1f2a6f698901be6e6be4b558b349a2313b1538c3 as release

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
