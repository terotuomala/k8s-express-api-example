# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:97ac65f0b4e49f62914162a85a0cccd2734f130c474b05d799a1b933cc7a70c2 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:97ac65f0b4e49f62914162a85a0cccd2734f130c474b05d799a1b933cc7a70c2 as release

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
