FROM node:21-slim@sha256:22184d39b62ad56a5fedd7c1c9e9a04280e51ba5864e88881537e65931ef8479 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:22184d39b62ad56a5fedd7c1c9e9a04280e51ba5864e88881537e65931ef8479 as release

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
