# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:f6c05914c890eb9a36836503015b21a38f54eca322b5de9a3ef475b32d7f4172 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:f6c05914c890eb9a36836503015b21a38f54eca322b5de9a3ef475b32d7f4172 as release

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
