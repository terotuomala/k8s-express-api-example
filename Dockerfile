# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:9c05ef173d74220ed3eb587324bd13ef30ced51e00f3899cd0d909b56d6ff028 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:9c05ef173d74220ed3eb587324bd13ef30ced51e00f3899cd0d909b56d6ff028 as release

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
