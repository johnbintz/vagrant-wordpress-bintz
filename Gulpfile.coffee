gulp = require('gulp')
browserify = require('browserify')
watchify = require('watchify')
coffeeReactify = require('coffee-reactify')
glob = require('glob')
path = require('path')
source = require('vinyl-source-stream')
spawn = require('child_process').spawn

makeBrowserify = (file) ->
  [sourcePath..., _, _] = file.split(path.sep)
  target = sourcePath.concat(['js', 'app.js']).join(path.sep)

  b = browserify({
    entries: ['./' + file]
    debug: true
    extensions: ['.js', '.coffee', '.cjsx']
    paths: [path.join(path.sep)]
    cache: {}
    packageCache: {}
    fullPaths: true
  }).transform(coffeeReactify)

  bundle = b.bundle

  b.bundle = ->
    console.log "Browserifying #{file}..."

    bundle
      .call(b)
      .pipe(source(path.basename(target)))
      .pipe(gulp.dest(path.dirname(target)))

  b

gulp.task 'watch', ->
  gulp.watch './**/sass/app.scss', ['styles']
  glob '**/coffee/app.coffee', (err, files) ->
    files.forEach (file) ->
      b = watchify(makeBrowserify(file))
      b.on 'update', b.bundle
      b.bundle()

gulp.task 'styles', ->
  glob '**/sass/app.scss', (err, files) ->
    files.forEach (file) ->
      [sourcePath..., _, _] = file.split(path.sep)
      appPath = sourcePath.join(path.sep)
      child = spawn 'bundle', [
        'exec', 'compass', 'compile',
        appPath, file, '--css-dir', 'css'
      ]
      child.stdout.pipe(process.stdout)
      child.stderr.pipe(process.stderr)

gulp.task 'scripts', ->
  glob '**/coffee/app.coffee', (err, files) ->
    files.forEach (file) ->
      makeBrowserify(file).bundle()

gulp.task 'default', ['watch']
