# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:e7c6a8ed332250fdbc96c9a995af20adb0243bbff0c7dcaca74c7254dbef795b as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:e7c6a8ed332250fdbc96c9a995af20adb0243bbff0c7dcaca74c7254dbef795b as release

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
