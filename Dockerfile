# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:9973b820ed90356392100759ed63a490e6fa7b430a33b02330058479a67be919 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:9973b820ed90356392100759ed63a490e6fa7b430a33b02330058479a67be919 as release

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
