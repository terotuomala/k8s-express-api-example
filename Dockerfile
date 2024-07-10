# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:c07aebbc4ee6d6380a4124a103dbd7f3952a51e10db719d4d6a6f043a178bf66 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:c07aebbc4ee6d6380a4124a103dbd7f3952a51e10db719d4d6a6f043a178bf66 as release

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
