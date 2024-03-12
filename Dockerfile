FROM node:21-slim@sha256:ab9d8781cb3fe8b6429d68c6ce19512a4ff526a6688240249ca15069b8124626 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:ab9d8781cb3fe8b6429d68c6ce19512a4ff526a6688240249ca15069b8124626 as release

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
