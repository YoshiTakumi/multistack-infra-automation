FROM node:18-slim

# add curl for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/app

# have nodemon available for local dev use (file watching)
RUN npm install -g nodemon

COPY package*.json ./

RUN npm ci && \
    npm cache clean --force && \
    mv /usr/local/app/node_modules /node_modules

COPY . .

# Set default environment variables for both the application and PostgreSQL connection
ARG PORT=80 \
    PG_HOST=db \
    PG_PORT=5432 \
    PG_USER=postgres \
    PG_PASSWORD=postgres \
    PG_DATABASE=postgres

ENV PORT=${PORT} \
    PG_HOST=${PG_HOST} \
    PG_PORT=${PG_PORT} \
    PG_USER=${PG_USER} \
    PG_PASSWORD=${PG_PASSWORD} \
    PG_DATABASE=${PG_DATABASE}

EXPOSE 80

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["node", "server.js"]
