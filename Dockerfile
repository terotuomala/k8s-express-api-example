# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:c02b7ddc99759168c6a0c442f4c1fe439b61abf002aa4e87f45e268aa32d8b06 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:c02b7ddc99759168c6a0c442f4c1fe439b61abf002aa4e87f45e268aa32d8b06 as release

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
