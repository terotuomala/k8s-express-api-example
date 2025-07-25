# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:7cd2ca1eb5c25f15c44d76bc573eec1605ee458ca833b9c600fdda79a0446b6e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:7cd2ca1eb5c25f15c44d76bc573eec1605ee458ca833b9c600fdda79a0446b6e as release

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
