#!/usr/bin/env bash
set -Eeuo pipefail

scriptdir="$(dirname "$0")"
cd "$scriptdir"

if [ -d "data/.wine/drive_c/Program Files/TmNationsForever/" ]; then
    EXTRA_ARGS="--user $(id -u):$(id -g)"
    CMD=""
    DISABLE_PULSE=false

    if ! [ -z "${1-}" ]; then
        if [ "$1" == "-b" ] || [ "$1" == "--build" ]; then
            docker-compose build tmnf
        elif [ "$1" == "-n" ] || [ "$1" == "--no-pulse" ]; then
            DISABLE_PULSE=true
        elif [ "$1" == "-p" ] || [ "$1" == "--pull" ]; then
            docker-compose pull tmnf
        elif [ "$1" == "-s" ] || [ "$1" == "--settings" ]; then
            CMD="wine TmForeverLauncher.exe"
        else
            if ! [ "$1" == "-h" ] && ! [ "$1" == "--help" ]; then
                echo "Got unrecognized option $1"
            fi
            echo "Usage: run.sh [OPTION]"
            echo "Valid options are (only a single option is recognized):"
            echo "  -b, --build       Rebuild docker image before starting the game."
            echo "  -h, --help        Show this help message."
            echo "  -n, --no-pulse    Disable pulse audio."
            echo "  -p, --pull        Pull docker image before starting the game."
            echo "  -s, --settings    Open game settings."
            exit 0
        fi
    fi

    if which pactl > /dev/null && ! $DISABLE_PULSE; then
        echo "Using pulse audio."
        PULSE_SOCKET="/tmp/pulseaudio.socket"
        if ! [ -S "$PULSE_SOCKET" ]; then
            pactl load-module module-native-protocol-unix socket="$PULSE_SOCKET"
        fi
        EXTRA_ARGS+=" -e PULSE_SERVER=unix:$PULSE_SOCKET"
        EXTRA_ARGS+=" -e PULSE_COOKIE=/tmp/pulseaudio.cookie"
        EXTRA_ARGS+=" -v $PULSE_SOCKET:$PULSE_SOCKET"
    fi

    docker-compose run --rm $EXTRA_ARGS tmnf $CMD
    exit 0
fi


if [[ "$(docker images -q myimage:mytag 2> /dev/null)" == "" ]]; then
    echo "Pulling Docker image…"
    docker-compose pull tmnf
fi

echo "Installing TMNF …"

if [ -f "tmnationsforever_setup.exe" ] ; then
    echo -e "\e[32m✔\e[0m tmnationsforever_setup.exe"
else
    echo -e "\e[31mPlease download tmnationsforever_setup.exe from"
    echo -e "http://trackmaniaforever.com/nations/"
    echo -e "Aborting.\e[0m"
    exit 1
fi

if [ -d "/tmp/.X11-unix" ]; then
    echo -e "\e[32m✔\e[0m X11 socket"
else
    echo -e "\e[31mCan't find the X11 domain socket at /tmp/.X11-unix, aborting.\e[0m"
    exit 1
fi

mkdir -p data

echo "In the next step the TMNF installation GUI should open."
echo "You need to use the preset default installation directory."
read -p "Press enter to continue …"
docker-compose run --rm --user $(id -u):$(id -g) -w /tmp tmnf wine tmnationsforever_setup.exe

echo -e "\e[32mInstallation succesfull! Run again to start game.\e[0m"
