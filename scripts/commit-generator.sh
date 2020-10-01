#!/bin/bash

. $(dirname "$0")/utils/chalk.sh

h2Info "Downloading commit generator..."
git clone "https://github.com/lintingzhen/commitizen-go"

h2Info "Dependencies package checking..."
go get -v ${PWD}/commitizen-go

h2Info "Building package"
go build ${PWD}/commitizen-go
make -C ${PWD}/commitizen-go


${PWD}/commitizen-go/commitizen-go install

h2Info "Cleaning up..."
rm -rf commitizen-go