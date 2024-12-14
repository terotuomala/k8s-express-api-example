# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:a5dc795c9589c81a6b9ce4fe91f4c4f1e1f15e936727f3b258bb871228ba17cc as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:a5dc795c9589c81a6b9ce4fe91f4c4f1e1f15e936727f3b258bb871228ba17cc as release

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
