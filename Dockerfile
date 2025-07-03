# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:d7f295566478c9f8b8927a077d05eacd8261ca8e0caa58f7f42c7baac98611fc as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:d7f295566478c9f8b8927a077d05eacd8261ca8e0caa58f7f42c7baac98611fc as release

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
