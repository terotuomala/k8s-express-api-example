# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:b2e71d47c55c65ed99134551c04e0844cdfba6c59b991f408bd2fc98327e2969 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:b2e71d47c55c65ed99134551c04e0844cdfba6c59b991f408bd2fc98327e2969 as release

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
