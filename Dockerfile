# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:4f58d2d01f9694394a8a2513e6fabbe5cc8c47d14b0c7a6709a234880b1193a1 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:4f58d2d01f9694394a8a2513e6fabbe5cc8c47d14b0c7a6709a234880b1193a1 as release

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
