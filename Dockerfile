# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:74b28494d25c04046835cf2ebb354c992129f9c73a633f051090889d14e0b6f6 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:74b28494d25c04046835cf2ebb354c992129f9c73a633f051090889d14e0b6f6 as release

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
