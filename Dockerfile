# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:cfe1722584d9265e3f151134417183fc26b48582cff1128514816d620314a5af as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:cfe1722584d9265e3f151134417183fc26b48582cff1128514816d620314a5af as release

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
