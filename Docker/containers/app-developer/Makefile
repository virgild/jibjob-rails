TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/app-developer" .

.PHONY: tag
tag:
	docker tag -f jibjob/app-developer jibjob/app-developer:$(TAG_VERSION)

push: build tag
	docker push jibjob/app-developer:$(TAG_VERSION)
