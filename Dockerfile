# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:cafde9c11fc0b13d203f33bf6137b8193513c895b0dca65e671683c392536d00 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:cafde9c11fc0b13d203f33bf6137b8193513c895b0dca65e671683c392536d00 as release

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
