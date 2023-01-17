#!/usr/bin/env bash

STATNGROK=curl -s http://127.0.0.1:4040/api/tunnels | jq '.tunnels | .[] | "\(.name) \(.public_url)"'
echo $STATNGROK
