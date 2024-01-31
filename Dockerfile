FROM node:21-slim@sha256:9fd8f4e825597da0b38f51b112ad3eb10e3bc6be33d61150bb21e8b9218556c1 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:9fd8f4e825597da0b38f51b112ad3eb10e3bc6be33d61150bb21e8b9218556c1 as release

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
