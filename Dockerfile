# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:df42488a9837aba987b588c1c9311dbca3e71310bdab88c607a3b287ece9fa85 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:df42488a9837aba987b588c1c9311dbca3e71310bdab88c607a3b287ece9fa85 as release

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
