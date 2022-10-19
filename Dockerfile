FROM node:19-slim@sha256:55ad5338aba24b8e9efdaeedf38fdf759c648d840991117b2c442373351995fe as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM node:19-slim@sha256:55ad5338aba24b8e9efdaeedf38fdf759c648d840991117b2c442373351995fe as release

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
