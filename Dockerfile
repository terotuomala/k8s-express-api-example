# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:8faf657d5c4b3424cfd3e33cc62f7fb3702e67a3fe676882353dbc37437ef890 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:8faf657d5c4b3424cfd3e33cc62f7fb3702e67a3fe676882353dbc37437ef890 as release

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
