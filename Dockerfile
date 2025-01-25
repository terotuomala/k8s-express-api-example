# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:ad8b46c563f3e6e0aa90bcec726e36d951c35cfca50b601889f9a42bfcc86bad as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:ad8b46c563f3e6e0aa90bcec726e36d951c35cfca50b601889f9a42bfcc86bad as release

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
