#!/bin/sh

case $1 in
  monitor) exec /monit.sh ;;
  *) exec $@;;
esac
