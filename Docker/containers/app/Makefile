TAG_VERSION=`cat ./Version`

.PHONY: build push

all: build

build:
	docker build -t="jibjob/app:$(TAG_VERSION)" .

push: build
	docker push jibjob/app:$(TAG_VERSION)
