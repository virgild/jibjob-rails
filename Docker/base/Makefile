TAG_VERSION=`cat ./Version`

.PHONY: build
build:
	@echo Building jibjob/base
	@docker build -t="jibjob/base" .
tag:
	@echo Tagging jibjob/base:$(TAG_VERSION)
	@docker tag -f jibjob/base jibjob/base:$(TAG_VERSION)
push:
	@echo Pushing jibjob/base:$(TAG_VERSION)
	@docker push jibjob/base:$(TAG_VERSION)
