#!/bin/bash

show_help() {
    echo "Usage: $0 --ip=<ip> --port=<port> --domain=<domain> [--o=<output>]"
    echo
    echo "Options:"
    echo "  --ip=<ip>       Set the IP address for the proxy_pass directive."
    echo "  --port=<port>   Set the port for the proxy_pass directive."
    echo "  --domain=<domain> Set the domain for the server_name directive and SSL certificate paths."
    echo "  --o=<output>    Specify the output file to save the configuration. If not provided, the configuration will be printed to the terminal."
    echo "  --help          Display this help message and exit."
    echo
    echo "Example:"
    echo "  $0 --ip=192.168.1.1 --port=8080 --domain=example.com"
    echo "  $0 --ip=192.168.1.1 --port=8080 --domain=example.com --o=example.conf"
}

IP=""
PORT=""
DOMAIN=""
OUTPUT=""

for i in "$@"
do
case $i in
    --ip=*)
    IP="${i#*=}"
    shift
    ;;
    --port=*)
    PORT="${i#*=}"
    shift
    ;;
    --domain=*)
    DOMAIN="${i#*=}"
    shift
    ;;
    --o=*)
    OUTPUT="${i#*=}"
    shift
    ;;
    --help)
    show_help
    exit 0
    ;;
    *)
    # unknown option
    ;;
esac
done

if [ -z "$IP" ] || [ -z "$PORT" ] || [ -z "$DOMAIN" ]; then
    show_help
    exit 1
fi

CONFIGURATION=$(cat << EOF
server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://\$host\$request_uri;
}

server {
    listen              443 ssl http2;
    ssl_certificate     /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

    client_max_body_size 5m;

    proxy_set_header Host               \$host;
    proxy_set_header Connection         "upgrade";
    proxy_set_header Upgrade            \$http_upgrade;
    proxy_set_header X-Real-IP          \$remote_addr;
    proxy_set_header X-Forwarded-Server \$host;
    proxy_set_header X-Forwarded-Proto  \$scheme;
    proxy_set_header X-Forwarded-Port   \$server_port;
    proxy_set_header X-Forwarded-Host   \$host:\$server_port;
    proxy_set_header X-Forwarded-For    \$proxy_add_x_forwarded_for;

    server_name  ${DOMAIN};
    access_log   /logs/${DOMAIN}.access.log  main;

    location / {
        proxy_pass      http://${IP}:${PORT};
    }
}
EOF
)

if [ -n "$OUTPUT" ]; then
    echo "$CONFIGURATION" > "$OUTPUT"
    echo "Nginx configuration for ${DOMAIN} saved to ${OUTPUT}."
else
    echo "$CONFIGURATION"
fi
