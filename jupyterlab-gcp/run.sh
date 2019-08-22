#!/bin/bash

docker run -d -p 80:80 $(basename `git rev-parse --show-toplevel`):$(git log --pretty=format:'%h' -n 1)
sleep 3
google-chrome http://localhost/lab
