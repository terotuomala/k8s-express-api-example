# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:90edf0892eeabd1e6ad558c0645b234b2f783304da5bf20f709ef5b8d79a57e2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:90edf0892eeabd1e6ad558c0645b234b2f783304da5bf20f709ef5b8d79a57e2 as release

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
