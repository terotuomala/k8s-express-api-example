# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:ffcc470ef9b6d2715eed2fe84cb342e11b9e438e37aa800ca5e2c5013d8d8b0b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:ffcc470ef9b6d2715eed2fe84cb342e11b9e438e37aa800ca5e2c5013d8d8b0b as release

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
