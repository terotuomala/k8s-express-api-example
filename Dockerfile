# syntax=docker/dockerfile:1
FROM chainguard/node-lts@sha256:ab2d52df4598b29dd53427c049db8b3ae4a9969a2b0a1daf604e7dd77b9c3e81 as build

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --production

COPY . .


FROM chainguard/node-lts@sha256:ab2d52df4598b29dd53427c049db8b3ae4a9969a2b0a1daf604e7dd77b9c3e81 as release

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
