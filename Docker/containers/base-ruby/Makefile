TAG_VERSION=`cat ./Version`

.PHONY: build tag push

all: tag

build:
	docker build -t="jibjob/base-ruby" .

tag: build
	docker tag -f jibjob/base-ruby jibjob/base-ruby:$(TAG_VERSION)

push: tag
	docker push jibjob/base-ruby:$(TAG_VERSION)
