# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:c6a9700c384a1fd57c39ba30ff2155cb2e3310655ecb75d4b05bfa3ecb3e08e6 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:c6a9700c384a1fd57c39ba30ff2155cb2e3310655ecb75d4b05bfa3ecb3e08e6 as release

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
