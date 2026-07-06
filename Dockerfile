# syntax=docker/dockerfile:1
FROM chainguard/node@sha256:1f7d8d710a221b7b634cb05db963dd54f3964a96616c8c9ed974ea2d2eca3695 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node@sha256:1f7d8d710a221b7b634cb05db963dd54f3964a96616c8c9ed974ea2d2eca3695 as release

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
