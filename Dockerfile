FROM node:21-slim@sha256:3129012701c02c7eb1db845f24a36223857c8ebdfd43a28569aa3f42d318f9de as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:21-slim@sha256:3129012701c02c7eb1db845f24a36223857c8ebdfd43a28569aa3f42d318f9de as release

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
