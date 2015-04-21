TAG_VERSION=`cat ./Version`

all: build

.PHONY: build push

build:
	docker build -t="jibjob/app-developer:$(TAG_VERSION)" .

push: build
	docker push jibjob/app-developer
	docker push jibjob/app-developer:$(TAG_VERSION)
