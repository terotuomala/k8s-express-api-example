# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:3e4c0d11ed4c4e77b7d1537ddf2915ed4bfe2faddd30e889370a8f12f1497074 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:3e4c0d11ed4c4e77b7d1537ddf2915ed4bfe2faddd30e889370a8f12f1497074 as release

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
