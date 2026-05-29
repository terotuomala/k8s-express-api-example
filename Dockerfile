# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:045335a479d6c59bab89e3caaaf9ed2aed5528d92e2431a3e2afcbf258dba9a6 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:045335a479d6c59bab89e3caaaf9ed2aed5528d92e2431a3e2afcbf258dba9a6 as release

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
