TAG_VERSION=`cat ./Version`

.PHONY: build tag

all: tag

build:
	docker build -t="jibjob/app" .

tag: build
	docker tag -f jibjob/app jibjob/app:$(TAG_VERSION)

push:
	docker push jibjob/app:$(TAG_VERSION)
