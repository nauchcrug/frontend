module.exports = """<!DOCTYPE html>
<html lang="ru" #{if production then 'manifest="manifest.appcache"'}>
<head>
  <title>Nauchkrug</title>
  <meta charset="UTF=8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="shortcut icon" href="#{require 'images/favicon.ico'}">
  <style>#{require '!css?minimize!postcss!sass!styles/index.sass'}</style>
</head>
<body>
  <app>
    <h1>TEST</h1>
  </app>
</body>
</html>"""
