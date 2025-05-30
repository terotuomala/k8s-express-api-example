# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:6ffe2cb0fd5bc53b5091d98661adfebbf21d6f5be31c7d0a4038cf14e4e11629 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:6ffe2cb0fd5bc53b5091d98661adfebbf21d6f5be31c7d0a4038cf14e4e11629 as release

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
