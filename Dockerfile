# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:862c7b01cf268adb550bc49f228115e132cac0d183395c92368bbb6c8eb7c098 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:862c7b01cf268adb550bc49f228115e132cac0d183395c92368bbb6c8eb7c098 as release

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
