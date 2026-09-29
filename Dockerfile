# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:78a8d37362503110e162d3f4e3f60362ff85429a34e0c810c68828b98c699e88 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:78a8d37362503110e162d3f4e3f60362ff85429a34e0c810c68828b98c699e88 as release

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
