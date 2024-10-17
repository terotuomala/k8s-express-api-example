# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:e2457b2fa975dc3cc35f3926d2128518aa16c7f750e8fb35e7c5623e95c92ca7 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:e2457b2fa975dc3cc35f3926d2128518aa16c7f750e8fb35e7c5623e95c92ca7 as release

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
