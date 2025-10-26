# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:2c7592c9a14cb4685fcbd0f494dfe0a98d3226ef20ac7950574a95f591c613f9 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:2c7592c9a14cb4685fcbd0f494dfe0a98d3226ef20ac7950574a95f591c613f9 as release

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
