# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:e0b651471ea55846dbfe9f820a871b88448e43066bab0c2e0700c3c5cc1e6686 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:e0b651471ea55846dbfe9f820a871b88448e43066bab0c2e0700c3c5cc1e6686 as release

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
