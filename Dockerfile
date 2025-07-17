# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:0901d5011135154b3723642a2daf0d0a73b8c7c0b51c76de7d744463994831c8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:0901d5011135154b3723642a2daf0d0a73b8c7c0b51c76de7d744463994831c8 as release

# Switch to non-root user uid=65532(node)
USER node

# Set environment variables
ENV NPM_CONFIG_LOGLEVEL=warn
ENV NODE_ENV=production

# Change working directory
WORKDIR /app

# Copy app directory from build stage
COPY --link --chown=65532 --from=build /app .

EXPOSE 3001

CMD ["src/index.js"]
