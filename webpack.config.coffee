# coffeelint: disable=max_line_length
webpack = require 'webpack'
{join, resolve} = require 'path'
extend = require 'lodash/extend'
fs = require 'fs'

api = 'http://localhost/~bsdfun/guestbook/web/'
publicPath = ''

#merge = require 'webpack-merge'
ExtractTextPlugin = require 'extract-text-webpack-plugin'
#ProgressBarPlugin = require 'progress-bar-webpack-plugin'
HtmlPlugin = require 'html-webpack-plugin'
OfflinePlugin = require 'offline-plugin'

styles =
  plugin: new ExtractTextPlugin filename: 'static/styles.[hash].css', allChunks: on
  extract: (loader) -> if production then @plugin.extract {fallbackLoader: 'style', loader} else "style!#{loader}"
  common: 'css?minimize&sourceMap&importLoaders=1'
  sass: -> @common + '&modules' + '!postcss!sass?sourceMap'
  css: -> @common + '&modules!postcss'

{NODE_ENV} = process.env
production = NODE_ENV is 'production'

# Plugins
plugins =
  common: [
    new webpack.DefinePlugin
      "process.env.NODE_ENV": JSON.stringify NODE_ENV
      "NODE_ENV": JSON.stringify NODE_ENV
      "production": JSON.stringify production
      "__DEV__": JSON.stringify production
  ]
  development: [
    new webpack.NoErrorsPlugin
    new webpack.HotModuleReplacementPlugin
  ]
  production: [
    new webpack.optimize.DedupePlugin
    new webpack.optimize.AggressiveMergingPlugin,
    #new webpack.optimize.OccurenceOrderPlugin,
    new webpack.optimize.UglifyJsPlugin
      compress:
        drop_console: on
        unsafe: on
        warnings: off
      mangle: on
      #screw_ie8: on
      sourceMap: on
    new OfflinePlugin
      AppCache:
        publicPath: ''
        directory: ''
  ]
  prefetch: do -> new webpack.PrefetchPlugin module  for module in []
  devserver: [
    #"react-hot-loader/patch"
    "webpack-dev-server/client?http://localhost:3000"
    "webpack/hot/dev-server"
    #"webpack-hot-middleware/client"
    #"babel-polyfill"
  ]
  postcss: [
    #require('autoprefixer')(['last 2 versions'])
    require 'postcss-cssnext'
    require 'postcss-svgo'
    require 'postcss-circle'
    require 'postcss-center'
    require 'postcss-animation'
    require 'postcss-triangle'
    require 'postcss-instagram'
    #require 'postcss-sprites'
    #require 'cssnano'
  ].concat if not production then [] else [
  ]

# Loaders
loaders = [{
  test: /\.ts$/
  loader: 'ts-loader'
},{
  test: /\.js$/
  loaders: ['babel-loader']
  #include: resolve __dirname, './src'
  #plugins: ['transform-runtime']
  #query: presets: ['es2015', 'stage-0', 'react']
  query: presets: ['es2015', 'stage-0']
},{
  test: /\.coffee$/
  loader: 'coffee'
  exclude: /node_modules/
},{
  test: /\.cson$/
  loader: 'cson'
},{
  test: /\.(scss|sass)$/
  loader: styles.extract do styles.sass
},{
  test: /\.css$/
  loader: styles.extract do styles.css
},{
  test: /\.md$/
  loader: 'markdown'
  #},{
  #test: /\.(png|jpg|ico|svg|eot|ttf|woff(2))/
  #loader: 'file?name=static/[name].[hash].[ext]'
},{
  test: /\.(eot|ttf|woff(2))$/
  loader: 'url?limit=100000&name=static/[name].[hash].[ext]'
},{
  test: /\.(png|jpg|ico|svg)$/
  loader: 'url?limit=100000&name=static/[name].[hash].[ext]!image-webpack?optimizationLevel=9'
}]
  
config =
  name: 'Guestbook'
  target: 'web'
  entry:
    bundle: ['./src/entry'].concat if not production then plugins.devserver else []
    vendor: []
  devtool: if production then 'source-map' else 'cheap-module-source-map'
  #'eval-source-map'
  devServer:
    publicPath: publicPath
    hot: on
    inline: on
    stats: 'error-only'
    contentBase: 'dist'
    historyApiFallback: off
    colors: on
    noInfo: off
    progress: yes
    progress: on
    port: 3000
    proxy:
      '/api': target: api, secure: false
  debug: off #production
  postcss: -> plugins.postcss
  sassLoader:
    includePath: [resolve __dirname, './node_modules']
  output:
    path: resolve './dist'
    publicPath: if production then publicPath else ''
    filename: 'static/[name].[hash].js'
    chunkFilename: 'static/[name].[hash].js'
    sourcemapFilename: 'static/[name].map'
    #sourceMapFilename: 'static/[name].map'
    libraryTarget: "umd"
  resolve:
    extensions: ['', '.ts', '.js', '.coffee', '.cson', '.sass', '.css', '.json']
    alias:
      'components': resolve './src/components'
      'styles': resolve './src/styles'
      'lib': resolve './src/lib'
      'images': resolve './src/assets/images'
      'fonts': resolve './src/assets/fonts'
  module: loaders: loaders
  plugins: [
    plugins.common...
    plugins.prefetch...
    styles.plugin
    new webpack.optimize.CommonsChunkPlugin
      name: 'vendor'
      filename: 'static/[name].[hash].js'
    new HtmlPlugin
      template: './src/assets/index.html.coffee'
      cache: yes
      hash: yes
    plugins[if production then 'production' else 'development']...
  ]

module.exports = config
