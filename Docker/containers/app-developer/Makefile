TAG_VERSION=`cat ./Version`

all: tag

.PHONY: build tag

build:
	docker build -t="jibjob/app-developer" .

tag: build
	docker tag -f jibjob/app-developer jibjob/app-developer:$(TAG_VERSION)

push: build tag
	docker push jibjob/app-developer:$(TAG_VERSION)
