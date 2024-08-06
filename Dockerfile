# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:f3e05b553792773c5a414cf3fd0c10ee0f812792ed490e4265e60c8bba98979f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:f3e05b553792773c5a414cf3fd0c10ee0f812792ed490e4265e60c8bba98979f as release

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
