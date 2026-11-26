# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:3f0d2afa09a5b4ccf8cb9caf9457343d0128a7e1ca63ebe5f9932420fe96cfa4 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:3f0d2afa09a5b4ccf8cb9caf9457343d0128a7e1ca63ebe5f9932420fe96cfa4 as release

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
