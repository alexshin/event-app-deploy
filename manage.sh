#!/usr/bin/env bash

set -ex

function clear {
    docker-compose stop
    docker-compose kill
    docker-compose rm --force
    docker image rm --force alexshin/event-app-api
}


function run_cli {
    docker-compose exec app ./manage.py $1 $2 $3
}


function start_compose {
    if [ ! -f "./app.env" ]; then
        echo "You must have app.env file in the root directory"
        exit 1
    fi

    if [ ! -f "./postgres.env" ]; then
        echo "You must have postgres.env file in the root directory"
        exit 2
    fi

    docker-compose up -d
}

function update {
    docker pull alexshin/event-app-api
    clear
    start_compose
}


case "$@" in
    "start" ) start_compose ;;
    "clear" ) clear ;;
    "run_cli"* ) run_cli $2 $3 $4 ;;
    "update") update ;;
    *) docker-compose "$@" ;;
esac