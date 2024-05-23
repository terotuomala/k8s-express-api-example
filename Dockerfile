# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:5f1ae6e2d238462d7f0745b5aaa434eb623f3ab9b10a220fc1ece2df107e395f as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:5f1ae6e2d238462d7f0745b5aaa434eb623f3ab9b10a220fc1ece2df107e395f as release

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
