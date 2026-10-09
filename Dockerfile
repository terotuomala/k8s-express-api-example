# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:140e2bda3b36b7c19ffaff951f21942d05d24cc77089cd7a9d9c91aece88a549 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:140e2bda3b36b7c19ffaff951f21942d05d24cc77089cd7a9d9c91aece88a549 as release

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
