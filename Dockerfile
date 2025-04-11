# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:9264e0355021dd960a154b7553da356ae4161272c7c27e99c125a076d3c70113 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:9264e0355021dd960a154b7553da356ae4161272c7c27e99c125a076d3c70113 as release

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
