FROM node:18-slim@sha256:d900c28d8cbb51cee5473215e5941b6334d9b02da75ef60f490d4c0c13160bb1 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:18-slim@sha256:d900c28d8cbb51cee5473215e5941b6334d9b02da75ef60f490d4c0c13160bb1 as release

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
