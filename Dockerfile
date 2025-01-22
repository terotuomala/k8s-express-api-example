# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:66e3e578906c4e0fe32301ba6b5e9e87efd445b173a7a7c3949bca3de323ddb9 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:66e3e578906c4e0fe32301ba6b5e9e87efd445b173a7a7c3949bca3de323ddb9 as release

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
