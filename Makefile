R3="${GOPATH}/src/github.com/tokopedia/"
SCRIPT_DIR="${R3}/scripts"

setup:
	@bash ${PWD}/scripts/setup.sh

dep:
	@dep ensure -v

build:
	@go build -v -race -ldflags="-w -s"

run:
	@go build -v -race -ldflags="-w -s" && ./r3
