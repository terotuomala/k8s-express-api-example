# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:025313140b3c382739c4a16a024f4ec75448ec5d1c60c5614a3d12eb4da9af14 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:025313140b3c382739c4a16a024f4ec75448ec5d1c60c5614a3d12eb4da9af14 as release

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
