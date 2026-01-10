# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:1818f0dfa6116a7bcac82fdc7116b46f3a418f9ae84f1bf4954b8f615b5a71bd as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:1818f0dfa6116a7bcac82fdc7116b46f3a418f9ae84f1bf4954b8f615b5a71bd as release

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
