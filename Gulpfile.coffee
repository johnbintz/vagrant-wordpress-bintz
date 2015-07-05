gulp = require('gulp')
glob = require('glob')
path = require('path')
source = require('vinyl-source-stream')
spawn = require('child_process').spawn
webpack = require('webpack')

gulp.task 'scripts', ->
  glob './themes/**/coffee/app.coffee', (err, files) ->
    files.forEach (file) ->
      parts = file.split(path.sep)
      context = path.resolve(parts.slice(0, -1).join(path.sep))
      entry = ['.'].concat(parts.slice(-1)).join(path.sep)

      outputPath = path.resolve(parts.slice(0, -2).concat(['js']).join(path.sep))

      console.log context
      console.log entry
      console.log outputPath

      compiler = webpack(
        entry: entry
        context: context
        output:
          path: outputPath
          filename: 'app.js'
      )

gulp.task 'default', ['watch']
