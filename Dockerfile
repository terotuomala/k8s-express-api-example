# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:6a7fec5813bdf8b4c67c8699f24b9b977206fc25d8543fbdb88ddaf0b4f624e1 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:6a7fec5813bdf8b4c67c8699f24b9b977206fc25d8543fbdb88ddaf0b4f624e1 as release

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
