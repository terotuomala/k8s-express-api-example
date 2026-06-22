# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:cd685308172e6cefc15ef66813743d0ba498692fc4bb11a2e248f003ad1c6059 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:cd685308172e6cefc15ef66813743d0ba498692fc4bb11a2e248f003ad1c6059 as release

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
