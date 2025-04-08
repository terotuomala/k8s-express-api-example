# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:16ffb8b73711076fd111023e1efdec64beb4685b1866e881652b219333e7a72d as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:16ffb8b73711076fd111023e1efdec64beb4685b1866e881652b219333e7a72d as release

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
