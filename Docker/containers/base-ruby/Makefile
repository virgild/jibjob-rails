TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/base-ruby" .

.PHONY: tag
tag:
	docker tag -f jibjob/base-ruby jibjob/base-ruby:$(TAG_VERSION)

push: build tag
	docker push jibjob/base-ruby:$(TAG_VERSION)
