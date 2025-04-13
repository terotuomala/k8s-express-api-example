# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:c9f5d50b07504754da0140e0dc0a39c7ab9b55cf35dff827ff6d0876d054e7e7 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:c9f5d50b07504754da0140e0dc0a39c7ab9b55cf35dff827ff6d0876d054e7e7 as release

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
