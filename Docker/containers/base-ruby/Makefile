TAG_VERSION=`cat ./Version`

.PHONY: build push

all: build

build:
	docker build -t="jibjob/base-ruby:$(TAG_VERSION)" .

push: build
	docker push jibjob/base-ruby:$(TAG_VERSION)
