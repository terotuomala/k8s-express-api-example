# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:8e1189525a80564e0df5cec59bc4aa5d859869e6e7c05b0a4290682fbd53563e as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:8e1189525a80564e0df5cec59bc4aa5d859869e6e7c05b0a4290682fbd53563e as release

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
