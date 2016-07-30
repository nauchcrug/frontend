#SRC = src/*
#NPM = `npm bin`
BIN = `npm bin`
BACKEND = '../backend'

all: build

build:
	@env NODE_ENV=production $(BIN)/webpack ${ARGS}

serve:
	@#webpack-dev-server ${ARGS}
	@coffee server.coffee ${ARGS}

watch:
	@webpack --watch ${ARGS}

clean:
	@rm -rf dist

web: build
	@rm -rf $(BACKEND)/public/*
	@cp -R dist/* $(BACKEND)/public

.PHONY: all test clean doc build watch
