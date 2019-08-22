#!/bin/bash

# build - A script to create Dockerfile for Machine Learning Ops

##### Constants

mode=

##### Script to lunch build

build()
{
	case $mode in 
		s | SIMPLE )
		echo "Building from image"
		#### TODO: Maybe refresh
		docker build -t jupyter-cloudml:latest .
		;;
		l | LOCAL )
		echo "Building Local mode"
		docker build -t $(basename `git rev-parse --show-toplevel`):$(git log --pretty=format:'%h' -n 1) -t $(basename `git rev-parse --show-toplevel`):latest  .
		;;
		c | CLOUD )
		echo "Building Cloud mode"
		#### TODO: Maybe we should add some validation here
		gcloud builds submit --timeout=1200 --tag gcr.io/$(gcloud config get-value project 2> /dev/null)/$(basename `git rev-parse --show-toplevel`):$(git log --pretty=format:'%h' -n 1) --tag gcr.io/$(gcloud config get-value project 2> /dev/null)/$(basename `git rev-parse --show-toplevel`):latest . 
		;;	
	* )
	params
	exit 1
	esac
}

##### Instructions

usage()
{
    echo "usage: build.sh [-m --mode]"
}

params()
{
    echo "usage: build.sh -m [l LOCAL|c CLOUD|s SIMPLE]"
}

if [ $# -gt 0 ]; then

	while [ "$1" != "" ]; do
	    case $1 in -m | --mode )           
			shift
			mode=$1
			build
			;;
	        * )
			usage
	        exit 1
	    esac
	    shift
	done
else
	usage
	exit 1
fi


