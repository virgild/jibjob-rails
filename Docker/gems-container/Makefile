TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/gems-container" .

.PHONY: tag
tag:
	docker tag -f jibjob/gems-container jibjob/gems-container:$(TAG_VERSION)

push: build tag
	docker push jibjob/gems-container:$(TAG_VERSION)
