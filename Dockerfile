# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:7b789dda1b450abbe67cb2efc66c3cfa921533c308a41852994f3774e02dffcc as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:7b789dda1b450abbe67cb2efc66c3cfa921533c308a41852994f3774e02dffcc as release

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
