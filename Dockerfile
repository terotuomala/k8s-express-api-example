# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:76f3ec1bed4cac87d6fb0e7db9fa6471d6db66bdbd6b682800188d7a1f157474 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:76f3ec1bed4cac87d6fb0e7db9fa6471d6db66bdbd6b682800188d7a1f157474 as release

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
