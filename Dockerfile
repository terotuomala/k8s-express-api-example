# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:4e771308d07813bf9a1aa25299a45e5664533c47fe4c541c14498752f2dbc2dd as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:4e771308d07813bf9a1aa25299a45e5664533c47fe4c541c14498752f2dbc2dd as release

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
