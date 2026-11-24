# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:d5b583c60748012e09a4eb97befc0ce1342d9022d34aa65e605e2f3a6c33e9e9 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:d5b583c60748012e09a4eb97befc0ce1342d9022d34aa65e605e2f3a6c33e9e9 as release

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
