# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:c4eef5fc5d641289ed438a00ead0f180f2ae8ba35c570c04ecf99045747b613b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:c4eef5fc5d641289ed438a00ead0f180f2ae8ba35c570c04ecf99045747b613b as release

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
