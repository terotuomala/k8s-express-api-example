# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:996e345fa59187b2872b40a00f07399b2f7326db9a8adb01fd29e06ef630c196 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:996e345fa59187b2872b40a00f07399b2f7326db9a8adb01fd29e06ef630c196 as release

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
