# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:9cb13df6c9cf12a80967d16cc85687d4d70f5a6fd76001a9764aa08a34e6d2f5 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:9cb13df6c9cf12a80967d16cc85687d4d70f5a6fd76001a9764aa08a34e6d2f5 as release

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
