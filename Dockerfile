FROM node:19-slim@sha256:1f43c1eb0ebc271a1d4a971e6e64a6b7127f82d8309b4bf2f3a8e4c35ab0787c as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:1f43c1eb0ebc271a1d4a971e6e64a6b7127f82d8309b4bf2f3a8e4c35ab0787c as release

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
