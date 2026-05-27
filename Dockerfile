# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:371704b3c21eb47ea0d517a8d2a1ce8aa903b91f5c98f6bd7f24127ed4fe25b6 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:371704b3c21eb47ea0d517a8d2a1ce8aa903b91f5c98f6bd7f24127ed4fe25b6 as release

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
