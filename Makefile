#SRC = src/*
#NPM = `npm bin`
BIN = `npm bin`

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

web:
	@rm -rf ../web/static
	@cp -R dist/* ../web

.PHONY: all test clean doc build watch
