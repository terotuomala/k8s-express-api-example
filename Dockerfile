# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5bd243150066e7a574d9f26e4863fe5e6902b55a397ed829b3aafee2a021c5fa as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5bd243150066e7a574d9f26e4863fe5e6902b55a397ed829b3aafee2a021c5fa as release

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
