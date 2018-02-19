#!/bin/bash
set -xueo pipefail

IMAGE=snoyberg/stackage:nightly
LTSPATH="$HOME/.pier/downloads/stackage/plan/lts-10.3.yaml"
PACKAGES=stackage/packages.txt

stack --docker --docker-image $IMAGE build pier -j 1
stack --docker --docker-image $IMAGE runghc stackage/list-packages.hs -- $LTSPATH \
    > $PACKAGES
time stack --docker --docker-image $IMAGE \
    exec -- \
    pier build $(cat $PACKAGES) \
    --download-local \
    --pier-yaml=stackage/pier.yaml \
    --shake-arg=--keep-going \
    -j 2
