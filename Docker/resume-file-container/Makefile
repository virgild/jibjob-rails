TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	docker build -t="jibjob/resume-file-container" .

.PHONY: tag
tag:
	docker tag -f jibjob/resume-file-container jibjob/resume-file-container:$(TAG_VERSION)

push: build tag
	docker push jibjob/resume-file-container:$(TAG_VERSION)
