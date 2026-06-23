# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:7ce7491612c80eac34419a2d765ff73d4e1a5e791af0ef98c8d990b721340f46 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:7ce7491612c80eac34419a2d765ff73d4e1a5e791af0ef98c8d990b721340f46 as release

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
