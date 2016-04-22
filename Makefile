PATH := ~/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

.DEFAULT_GOAL := help

dev: ## reactive build
dev: clean buildc

build: ## build
build: bin clean
	stack build --ghc-options=-O2

buildc: ## reactive build
buildc: bin clean
	stack build --file-watch

builds: ## build with static linking
builds: bin claen
	stack build --ghc-options='-optl-static -optl-pthread' --force-dirty

buildv: ## build verbosely
buildv: bin clean
	stack build --verbose

clean: ## clean
	stack clean

clobber: ## clean
clobber: clean
	rm -rf .stack-work

APP ?= proxy
run: ## run $APP for testing where APP is an env. var.
	stack exec ${APP}

proxy: ## run proxy
	./bin/proxy -threaded +RTS -N -H2G

# bin dir
VER = $(shell stack ghc -- --version | awk '{print $$NF}')
LTS = $(shell egrep '^resolver:' stack.yaml | awk '{print $$2}')
bin:; rm -f bin && ln -fs .stack-work/install/x86_64-linux/${LTS}/${VER}/bin
# ---
info: ## version info
	@stack ghc -- --version
	@stack exec cabal -- --version
	@stack --version

# ---
init: ## init. dev. env.
	install-pgks
	stack setup

PKGS = librdkafka-dev
install-pkgs: ## instal packages
	sudo apt-get install -y ${PKGS}
# ---
GIT_SUBMODULE = git@gitlab.com:metaml/docker
add-submodule: ## add related git submodule
	[ -d lib ] || mkdir -p lib
	if [ ! -d lib/docker ]; then \
		(git rm -r --cached lib/docker >/dev/null 2>&1 || exit 0); \
		git submodule add --force ${GIT_SUBMODULE} lib/docker; \
	fi

help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
