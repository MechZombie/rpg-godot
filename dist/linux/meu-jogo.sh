#!/bin/sh
echo -ne '\033c\033]0;DemoRPG\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/meu-jogo.x86_64" "$@"
