# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:52e7a4dc5f1bc91e6819a191a5fbd36fcb101b696f3f04b235a83840a476412c as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:52e7a4dc5f1bc91e6819a191a5fbd36fcb101b696f3f04b235a83840a476412c as release

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
