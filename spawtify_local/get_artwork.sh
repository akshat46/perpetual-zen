#!/bin/bash
mkdir -p .spotify_widget
name=`echo $1 | sed 's/\//_/g' | sed 's/https:__[a-z\.]\+_//g'`
wget -O $PWD/.cache/artwork $1
