# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:a12d7e9c265c74a33a8c3b8ad592ac3a8d631209a7b05b4c7f44944caba8a682 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:a12d7e9c265c74a33a8c3b8ad592ac3a8d631209a7b05b4c7f44944caba8a682 as release

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
