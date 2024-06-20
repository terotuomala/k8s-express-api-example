# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:a17179efdf784c68203cff6adfffae0f97e3ca536e86410ad6d213b37b413b63 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:a17179efdf784c68203cff6adfffae0f97e3ca536e86410ad6d213b37b413b63 as release

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
