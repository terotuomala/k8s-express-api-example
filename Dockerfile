FROM node:21-slim@sha256:60c55eecda01d0d7e3299adf4edc95741eb73bf22d7d0aca8287b4287e589d27 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:60c55eecda01d0d7e3299adf4edc95741eb73bf22d7d0aca8287b4287e589d27 as release

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
