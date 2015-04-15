TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/app-worker" .

.PHONY: tag
tag:
	docker tag -f jibjob/app-worker jibjob/app-worker:$(TAG_VERSION)

push: build tag
	docker push jibjob/app-worker:$(TAG_VERSION)
