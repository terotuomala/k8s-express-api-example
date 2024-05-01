# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:51e9adb09d236da458aa0f1834b3447ad4c24873a31412c0684ee63abf2dd5df as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:51e9adb09d236da458aa0f1834b3447ad4c24873a31412c0684ee63abf2dd5df as release

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
