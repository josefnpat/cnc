#!/bin/sh

SRC_DIR=.

GIT_HASH=$(git log --pretty=format:'%h' -n 1 ${SRC_DIR})
GIT_COUNT=$(git log --pretty=format:'' ${SRC_DIR} | wc -l)

echo "v$GIT_COUNT [$GIT_HASH]"
