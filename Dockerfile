# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:f634e333fda216c612831b4258673ca42a77048e02e58aec4bc4d177349e569f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:f634e333fda216c612831b4258673ca42a77048e02e58aec4bc4d177349e569f as release

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
