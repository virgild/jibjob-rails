
all: build

build: containers/base \
		 	 containers/base-ruby \
		 	 containers/app \
		 	 containers/app-developer

.PHONY: containers/base
containers/base:
	@$(MAKE) -C $@;

.PHONY: containers/base-ruby
containers/base-ruby: containers/base
	@$(MAKE) -C $@;

.PHONY: containers/app
containers/app: containers/base-ruby
	@$(MAKE) -C $@;

.PHONY: containers/app-developer
containers/app-developer: containers/app
	@$(MAKE) -C $@;
