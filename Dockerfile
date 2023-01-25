FROM node:19-slim@sha256:8886b323f04105798b3e5aac31ab7cc9ee35ae71099fbd7cd6645e1d165dbf94 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:8886b323f04105798b3e5aac31ab7cc9ee35ae71099fbd7cd6645e1d165dbf94 as release

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
