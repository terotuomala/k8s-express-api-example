# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:681fce217d057966784cf9462277ab899fc5274b3c2dd0acd8a2e1ac757310cc as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:681fce217d057966784cf9462277ab899fc5274b3c2dd0acd8a2e1ac757310cc as release

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
