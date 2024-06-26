# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:47974321ecc8469ab01e043723eb4d3405e2750b5e8cf84e4884071b035bbbea as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:47974321ecc8469ab01e043723eb4d3405e2750b5e8cf84e4884071b035bbbea as release

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
