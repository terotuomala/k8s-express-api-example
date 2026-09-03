# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:716088322be7b5d08a5ae97d8d534f0d743ec06e16dc33ae170b015422262bd8 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:716088322be7b5d08a5ae97d8d534f0d743ec06e16dc33ae170b015422262bd8 as release

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
