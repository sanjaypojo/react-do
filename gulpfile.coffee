gulp = require "gulp"
plugins = require("gulp-load-plugins")()
runSequence = require("run-sequence")

# Paths
paths =
  distro:
    root: "distro/"
    css: "distro/css/"
    js: "distro/js/"
    images: "distro/images/"
    lib: "distro/lib/"
  test:
    root: "test/"
    css: "test/css/"
    js: "test/js/"
    images: "test/images/"
    lib: "test/lib/"
  watch:
    less: "src/styles/*.less"
    jade: "src/views/*.jade"
    coffee: "src/views/*.coffee"
    coffeeLib: "src/lib/*.coffee"
    cjsx: "src/views/*.cjsx"
  less: "src/styles/style.less"
  jade: "src/views/*.jade"
  coffee: "src/views/*.coffee"
  images: "src/images/*.*"
  coffeeLib: "src/lib/*.coffee"
  cjsx: "src/views/*.cjsx"

gulp.task "clean", () ->
  gulp.src paths.test.root, read: false
    .pipe plugins.clean()

gulp.task "jade", () ->
  gulp.src paths.jade
    .pipe plugins.jade()
    .on "error", plugins.util.log
    .pipe gulp.dest paths.test.root

gulp.task "less", () ->
  gulp.src paths.less
    .pipe plugins.less()
    .on "error", plugins.util.log
    .pipe gulp.dest paths.test.css

gulp.task "coffee", () ->
  gulp.src paths.coffee
    .pipe plugins.sourcemaps.init()
    .pipe plugins.coffee()
    .on "error", plugins.util.log
    .pipe plugins.sourcemaps.write()
    .pipe gulp.dest paths.test.js

gulp.task "images", () ->
  return gulp.src paths.images
    .pipe plugins.imagemin()
    .pipe gulp.dest(paths.test.images)

gulp.task "coffeeLib", () ->
  gulp.src paths.coffeeLib
    .pipe plugins.sourcemaps.init()
    .pipe plugins.coffee(bare: true)
    .on "error", plugins.util.log
    .pipe plugins.sourcemaps.write()
    .pipe gulp.dest paths.test.lib

gulp.task "cjsx", () ->
  gulp.src paths.cjsx
    .pipe plugins.sourcemaps.init()
    .pipe plugins.cjsx(bare: true)
    .on "error", plugins.util.log
    .pipe plugins.sourcemaps.write()
    .pipe gulp.dest paths.test.js

gulp.task "watch", () ->
  gulp.watch paths.watch.jade, ["jade"]
  gulp.watch paths.watch.less, ["less"]
  gulp.watch paths.watch.coffee, ["coffee"]
  gulp.watch paths.images, ["images"]
  gulp.watch paths.watch.coffeeLib, ["coffeeLib"]
  gulp.watch paths.watch.cjsx, ["cjsx"]

gulp.task "cleanDistro", () ->
  gulp.src paths.distro.root, read: false
    .pipe plugins.clean()

gulp.task "jadeDistro", () ->
  gulp.src paths.jade
    .pipe plugins.jade()
    .pipe gulp.dest paths.distro.root

gulp.task "lessDistro", () ->
  gulp.src paths.less
    .pipe plugins.less()
    .pipe plugins.minifyCss()
    .pipe gulp.dest paths.distro.css

gulp.task "coffeeDistro", () ->
  gulp.src paths.coffee
    .pipe plugins.coffee()
    .pipe gulp.dest paths.distro.js

gulp.task "imagesDistro", () ->
  return gulp.src paths.images
    .pipe plugins.imagemin()
    .pipe gulp.dest(paths.distro.images)

gulp.task "coffeeLibDistro", () ->
  gulp.src paths.coffeeLib
    .pipe plugins.coffee()
    .pipe plugins.uglify()
    .pipe gulp.dest paths.distro.lib

gulp.task "cjsxDistro", () ->
  gulp.src paths.cjsx
    .pipe plugins.cjsx()
    .pipe gulp.dest paths.distro.js

gulp.task "build", () ->
  runSequence "cleanDistro", ["jadeDistro", "lessDistro", "coffeeDistro","coffeeLibDistro", "cjsxDistro", "imagesDistro"]

gulp.task "default", () ->
  runSequence "clean", ["jade", "less", "coffee","coffeeLib", "cjsx", "images"]
