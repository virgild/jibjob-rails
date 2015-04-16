TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/app" .

tag:
	docker tag -f jibjob/app jibjob/app:$(TAG_VERSION)

push:
	docker push jibjob/app:$(TAG_VERSION)
