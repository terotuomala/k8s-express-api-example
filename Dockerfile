FROM node:19-slim@sha256:3d41bbdc64267e7d4eefcbbfa8a0d038da6fe84c55377b65955d8e77fff32a4b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:3d41bbdc64267e7d4eefcbbfa8a0d038da6fe84c55377b65955d8e77fff32a4b as release

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
