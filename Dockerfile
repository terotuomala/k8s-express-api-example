# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:7c1928c11b902bd7448086e9e7b62008e4185892d2c40f7adbc3d325617c4341 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:7c1928c11b902bd7448086e9e7b62008e4185892d2c40f7adbc3d325617c4341 as release

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
