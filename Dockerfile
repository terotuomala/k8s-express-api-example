# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:028402259a01d51240b388c9f1e953228109531803286905d341be0e3e48f5ea as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:028402259a01d51240b388c9f1e953228109531803286905d341be0e3e48f5ea as release

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
