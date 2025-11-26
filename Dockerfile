# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:ce8c260a89d8ea0e513726578e9ce25ce4387cf3d419463e41e26ade81ab7371 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:ce8c260a89d8ea0e513726578e9ce25ce4387cf3d419463e41e26ade81ab7371 as release

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
