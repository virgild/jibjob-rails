TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/base-app" .

tag:
	docker tag -f jibjob/base-app jibjob/base-app:$(TAG_VERSION)

push:
	docker push jibjob/base-app:$(TAG_VERSION)
