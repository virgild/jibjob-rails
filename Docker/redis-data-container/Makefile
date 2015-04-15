TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/redis-data-container" .

.PHONY: tag
tag:
	docker tag -f jibjob/redis-data-container jibjob/redis-data-container:$(TAG_VERSION)

push: build tag
	docker push jibjob/redis-data-container:$(TAG_VERSION)
