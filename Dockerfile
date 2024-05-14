# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:e89263ff561442401bd07633904ec8cf05fd2050414e81824f18213ee7573a51 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:e89263ff561442401bd07633904ec8cf05fd2050414e81824f18213ee7573a51 as release

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
