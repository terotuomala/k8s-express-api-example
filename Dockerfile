# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:94a0cde89bbfb535efc668b7065e67c0f87aa18470c5a2b679617cd596471d87 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:94a0cde89bbfb535efc668b7065e67c0f87aa18470c5a2b679617cd596471d87 as release

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
