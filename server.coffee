webpack = require 'webpack'
devserver = require 'webpack-dev-server'
config = require './webpack.config'

{port = 3000, host = 'localhost'} = config.devServer

new devserver webpack(config), config.devServer
  .listen port, host
