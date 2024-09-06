# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:5851789a8c729131e0aacc5943186f5b982d66b9dff4123a136a4c2fd44c782e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:5851789a8c729131e0aacc5943186f5b982d66b9dff4123a136a4c2fd44c782e as release

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
