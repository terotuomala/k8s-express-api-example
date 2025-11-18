# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:3c1dbe0ac714e64157ba9861d9b596ebec57d83eff0f8364a8197887db6d11bf as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:3c1dbe0ac714e64157ba9861d9b596ebec57d83eff0f8364a8197887db6d11bf as release

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
