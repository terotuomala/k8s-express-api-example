FROM node:19-slim@sha256:f5eb5c04eeb0bdaff44e179b84b57b8958f2fc6fb814641d3a5f3fe27d93e248 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:f5eb5c04eeb0bdaff44e179b84b57b8958f2fc6fb814641d3a5f3fe27d93e248 as release

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
