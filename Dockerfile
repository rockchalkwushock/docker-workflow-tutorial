# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
# Multistage build syntax was introduced in Docker Engine 17.05.

# Stage=0
FROM node:alpine

WORKDIR /app

COPY package.json .

RUN npm install --production

COPY . .

RUN npm run build

# Stage=1
FROM nginx
EXPOSE 80
COPY --from=0 /app/build /usr/share/nginx/html


# docker run -p 8080:80 rockchalkwushock/frontend_prod

# NOTE
# I get some bizarre output in the CLI and I'm not entirely sure why?
# Switching from 8080:8080 --> 8080:80 allows the app to run though:
# /docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
# /docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
# /docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
# 10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
# 10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
# /docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
# /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
# /docker-entrypoint.sh: Configuration complete; ready for start up