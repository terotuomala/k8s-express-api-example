# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:71e0fd45ffdb3562c98c421f191706f1d4cf07c384383f2c3bda7bddecc0b328 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:71e0fd45ffdb3562c98c421f191706f1d4cf07c384383f2c3bda7bddecc0b328 as release

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
