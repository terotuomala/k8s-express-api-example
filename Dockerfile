FROM node:19-slim@sha256:67a73455d3befb6ff5ab8cafd3481df3ec4c643eac9d15230e2d6f58c443e47c as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:67a73455d3befb6ff5ab8cafd3481df3ec4c643eac9d15230e2d6f58c443e47c as release

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
