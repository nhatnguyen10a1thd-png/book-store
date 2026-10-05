#!/bin/sh
set -eu

app_port="${PORT:-8080}"

case "${app_port}" in
    ''|*[!0-9]*)
        echo "PORT must be a number." >&2
        exit 1
        ;;
esac

sed -i "s/port=\"8080\"/port=\"${app_port}\"/" "${CATALINA_HOME}/conf/server.xml"

exec catalina.sh run
