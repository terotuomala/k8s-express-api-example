# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:280b5b23f0f84c53235c8c7749955c0f893cbd72e1388bdf86a049d8ba7c3073 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:280b5b23f0f84c53235c8c7749955c0f893cbd72e1388bdf86a049d8ba7c3073 as release

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
