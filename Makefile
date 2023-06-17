APP=$(shell basename $(shell git remote get-url origin) | cut -d '.' -f1)
REGISTRY=njrk
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux#linux darwin windows
TARGETARCH=amd64#arm64 amd64
CGO_ENABLED=0

linux:
	${MAKE} build TARGETOS=linux TARGETARCH=${TARGETARCH}

macos:
	${MAKE} build TARGETOS=darwin TARGETARCH=${TARGETARCH}

windows:
	${MAKE} build TARGETOS=windows TARGETARCH=${TARGETARCH}

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/Njrk/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH} --build-arg CGO_ENABLED=${CGO_ENABLED} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}