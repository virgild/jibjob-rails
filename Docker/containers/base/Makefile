TAG_VERSION=`cat ./Version`

.PHONY: build push

all: build

build:
	@echo Building jibjob/base
	@docker build -t="jibjob/base:$(TAG_VERSION)" .

push: build
	@echo Pushing jibjob/base:$(TAG_VERSION)
	@docker push jibjob/base:$(TAG_VERSION)
