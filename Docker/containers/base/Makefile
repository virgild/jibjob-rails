TAG_VERSION=`cat ./Version`

.PHONY: build tag push

all: tag

build:
	@echo Building jibjob/base
	@docker build -t="jibjob/base" .

tag: build
	@echo Tagging jibjob/base:$(TAG_VERSION)
	@docker tag -f jibjob/base jibjob/base:$(TAG_VERSION)

push: tag
	@echo Pushing jibjob/base:$(TAG_VERSION)
	@docker push jibjob/base:$(TAG_VERSION)
