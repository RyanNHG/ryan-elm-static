const path = require('path')
const fs = require('fs')
const gulp = require('gulp')
const pug = require('gulp-pug')
const elm = require('gulp-elm')

const paths = {
  pug: {
    src: 'index.pug',
    config: './config.json',
    dest: './_docs'
  },
  elm: {
    src: 'src/**/*.elm',
    out: 'app.js',
    dest: './_docs'
  },
  assets: {
    src: 'assets/**/*',
    dest: './_docs'
  }
}

// Elm
gulp.task('elm:init', elm.init)

gulp.task('elm', ['elm:init'], () =>
  gulp.src(paths.elm.src)
    .pipe(elm.bundle(paths.elm.out))
    .on('error', () => {})
    .pipe(gulp.dest(paths.elm.dest))
)

gulp.task('watch:elm', ['elm'], () =>
  gulp.watch(paths.elm.src, ['elm'])
)

// Pug
gulp.task('pug', () => {
  delete require.cache[path.join(__dirname, paths.pug.config)]
  require(paths.pug.config)
    .map((locals) => {
      if (locals.post) {
        const path = './posts/' + locals.post
        locals.flags = {
          title: locals.title,
          description: locals.description,
          post: fs.readFileSync(path, 'utf8')
        }
      }
      return locals
    })
    .map((locals) =>
      gulp.src(paths.pug.src)
        .pipe(pug({ locals, pretty: true }))
        .pipe(gulp.dest(path.join(paths.pug.dest, locals.path)))
    )
})

gulp.task('watch:pug', ['pug'], () => {
  gulp.watch(paths.pug.src, ['pug'])
  gulp.watch(paths.pug.config, ['pug'])
})

// Assets
gulp.task('assets', () =>
  gulp.src(paths.assets.src)
    .pipe(gulp.dest(paths.assets.dest))
)

gulp.task('watch:assets', ['assets'], () =>
  gulp.watch(paths.assets.src, ['assets'])
)

// Default tasks
gulp.task('build', ['elm', 'pug', 'assets'])
gulp.task('watch', ['watch:elm', 'watch:pug', 'watch:assets'])
gulp.task('default', ['build'])
