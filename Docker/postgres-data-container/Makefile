TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/postgres-data-container" .

.PHONY: tag
tag:
	docker tag -f jibjob/postgres-data-container jibjob/postgres-data-container:$(TAG_VERSION)

push: build tag
	docker push jibjob/postgres-data-container:$(TAG_VERSION)
