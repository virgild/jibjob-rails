"use strict";

var gulp = require('gulp');
var uglify = require('gulp-uglify');
var react = require('gulp-react');
var reactify = require('reactify');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var revAll = require('gulp-rev-all');
var gzip = require('gulp-gzip');
var del = require('del');
var concat = require('gulp-concat');
var wrapper = require('gulp-wrapper');
var sourcemaps = require('gulp-sourcemaps');
var merge = require('merge2');
var addsrc = require('gulp-add-src');
var gulpif = require('gulp-if');
var jshint = require('gulp-jshint');
var stylish_jshint = require('jshint-stylish');
var browserify = require('browserify');
var railsmanifest = require('gulp-rev-rails-manifest');
var source = require('vinyl-source-stream');
var watchify = require('watchify');
var buffer = require('vinyl-buffer');
var gutil = require('gulp-util');
var watch = require('gulp-watch');
var minifycss = require('gulp-minify-css');
var plumber = require('gulp-plumber');
var batch = require('gulp-batch');

var config = {
  bowerDir: './bower_components',
  railsEnv: process.env.RAILS_ENV || 'development',
};

gulp.task('default', function() {
  gutil.log("RAILS_ENV: " + config.railsEnv);
});

/* Clean */
gulp.task('clean', function(callback) {
  del(['./build', './public/assets', 'manifest.json'], callback);
});

/* Build */
gulp.task('build', [
  'javascript-lib',
  'javascript-app',
  'components-js',
  'publication-js',
  'sass',
  'fonts',
  'images',
  'data'
]);

/* Javascript - Third-party Javascript libraries */
gulp.task('javascript-lib', function() {
  var libFiles = [
    './app/assets/javascripts/polyfills/prototype_bind.js',
    config.bowerDir + '/jquery/dist/jquery.js',
    config.bowerDir + '/bootstrap-sass-official/assets/javascripts/bootstrap.js',
    config.bowerDir + '/d3/d3.js',
    config.bowerDir + '/moment/moment.js'
  ];

  return gulp.src(libFiles)
    .pipe(concat('library.js'))
    .pipe(gulp.dest('build/full/js'));
});

/* Javascript - App */
gulp.task('javascript-app', function() {
  return browserify()
    .require('./app/assets/javascripts/signup.js', { expose: 'signup' })
    .bundle()
    .pipe(source('app.js'))
    .pipe(gulp.dest('build/full/js'));
});

/* SASS */
gulp.task('sass', function() {
  var sassFiles = [
    "app/assets/stylesheets/application.scss",
    "app/assets/stylesheets/publication.scss",
    "app/assets/stylesheets/admin.scss"
  ];

  var sassConfig = {
    outputStyle: 'nested',
    sourceComments: true,
    sourceMap: false,
    includePaths: [
      config.bowerDir + '/bootstrap-sass-official/assets/stylesheets'
    ]
  };

  return gulp.src(sassFiles)
    .pipe(sass(sassConfig))
    .pipe(autoprefixer())
    .pipe(gulp.dest('build/full/css'));
});

/* Fonts */
gulp.task('fonts', function() {
  var fonts = [
    config.bowerDir + '/bootstrap-sass-official/assets/fonts/bootstrap/*'
  ];

  return gulp.src(fonts)
    .pipe(gulp.dest('build/full/fonts/bootstrap'));
});

/* Images */
gulp.task('images', function() {
  var images = [
    './app/assets/images/*'
  ];

  return gulp.src(images)
    .pipe(gulp.dest('build/full/images'));
});

/* Data */
gulp.task('data', function() {
  var dataFiles = [
    './app/assets/text/*'
  ];

  return gulp.src(dataFiles)
    .pipe(gulp.dest('build/full/text'));
});

/*********************************
* BROWSERIFY - ReactJS components
*********************************/
gulp.task('components-js', function() {
  return browserify()
    .transform(reactify)
    .require('react/addons', { expose: 'react/addons' })
    .require('./app/assets/javascripts/components/user_resume_list.jsx', { expose: 'user_resume_list' })
    .require('./app/assets/javascripts/components/resume_form.jsx', { expose: 'resume_form' })
    .require('./app/assets/javascripts/components/user_resume_page.jsx', { expose: 'user_resume_page' })
    .require('./app/assets/javascripts/components/resume_stats_page.jsx', { expose: 'resume_stats_page' })
    .bundle()
    .pipe(source('components.js'))
    .pipe(gulp.dest('build/full/js'));
});

/*******************
 *      WATCH      *
 *******************/
gulp.task('watch', function() {
  /* components.js */
  var components_js_bundler = browserify({
    transform: [reactify],
    cache: {},
    packageCache: {},
    fullPaths: false
  })
    .require('react/addons', { expose: 'react/addons' })
    .require('./app/assets/javascripts/components/user_resume_list.jsx', { expose: 'user_resume_list' })
    .require('./app/assets/javascripts/components/resume_form.jsx', { expose: 'resume_form' })
    .require('./app/assets/javascripts/components/user_resume_page.jsx', { expose: 'user_resume_page' })
    .require('./app/assets/javascripts/components/resume_stats_page.jsx', { expose: 'resume_stats_page' });

  var components_js_watcher = watchify(components_js_bundler);

  components_js_watcher.on('update', function() {
    gutil.log(gutil.colors.green("Updated ") + gutil.colors.yellow("components.js"));
    components_js_watcher.bundle()
      .pipe(source('components.js'))
      .pipe(gulp.dest('public/assets/js'));
  })
    .bundle()
    .pipe(source('components.js'))
    .pipe(gulp.dest('public/assets/js'));

  /* app.js */
  var app_js_bundler = browserify({ cache: {}, packageCache: {}, fullPaths: false })
    .require('./app/assets/javascripts/signup.js', { expose: 'signup' });

  var app_js_watcher = watchify(app_js_bundler);

  app_js_watcher.on('update', function() {
    gutil.log(gutil.colors.green("Updated ") + gutil.colors.yellow("app.js"));
    app_js_watcher.bundle()
      .pipe(source('app.js'))
      .pipe(gulp.dest('public/assets/js'));
  })
    .bundle()
    .pipe(source('app.js'))
    .pipe(gulp.dest('public/assets/js'));

  /* publication.js */
  var pub_js_bundler = browserify({
    transform: [reactify],
    cache: {},
    packageCache: {},
    fullPaths: false
  })
    .require('react/addons', { expose: 'react/addons' })
    .require('./app/assets/javascripts/components/publication_page.jsx', { expose: 'publication_page' });

  var pub_js_watcher = watchify(pub_js_bundler);

  pub_js_watcher.on('update', function() {
    gutil.log(gutil.colors.green("Updated ") + gutil.colors.yellow("publication.js"));
    pub_js_watcher.bundle()
      .pipe(source('publication.js'))
      .pipe(gulp.dest('public/assets/js'));
  })
    .bundle()
    .pipe(source('publication.js'))
    .pipe(gulp.dest('public/assets/js'));

  /* Sass files */
  gulp.src([
    "app/assets/stylesheets/application.scss",
    "app/assets/stylesheets/publication.scss",
    "app/assets/stylesheets/admin.scss"
  ])
    .pipe(watch('app/assets/stylesheets/**/*.scss', function(file) {
      gutil.log(gutil.colors.green("Updated ") + gutil.colors.yellow(file.path.replace(file.base, '')));
    }))
    .pipe(plumber())
    .pipe(sass({
      outputStyle: 'nested',
      sourceComments: true,
      sourceMap: false,
      includePaths: [
        config.bowerDir + '/bootstrap-sass-official/assets/stylesheets'
      ]
    }))
    .pipe(autoprefixer())
    .pipe(gulp.dest('public/assets/css'));
});

gulp.task('publication-js', function() {
  return browserify([
    './app/assets/javascripts/components/publication_page.jsx'
  ])
    .transform(reactify)
    .require('react/addons', { expose: 'react/addons' })
    .require('./app/assets/javascripts/components/publication_page.jsx', { expose: 'publication_page' })
    .bundle()
    .pipe(source('publication.js'))
    .pipe(gulp.dest('build/full/js'));
});

/* Compress */
gulp.task('compress', ['build'], function() {
  merge(
    gulp.src('build/full/css/*.css')
      .pipe(minifycss({ processImport: false, advanced: false, rebase: false }))
      .pipe(gulp.dest('build/compressed/css')),
    gulp.src('build/full/js/*.js')
      .pipe(uglify())
      .pipe(gulp.dest('build/compressed/js')),
    gulp.src('build/full/images/**/*')
      .pipe(gulp.dest('build/compressed/images')),
    gulp.src('build/full/fonts/**/*')
      .pipe(gulp.dest('build/compressed/fonts')),
    gulp.src('build/full/text/**/*')
      .pipe(gulp.dest('build/compressed/text'))
  );
});

/* Install */
gulp.task('install', function() {
  return gulp.src('build/compressed/**/*')
    .pipe(gulp.dest('public/assets'));
});

gulp.task('dev:install', ['build'], function() {
  return gulp.src('build/full/**/*')
    .pipe(gulp.dest('public/assets'));
});

/* Manifest */
gulp.task('manifest', function() {
  return gulp.src([
    'build/compressed/css/*.css',
    'build/compressed/js/*.js',
    'build/compressed/images/**/*',
    'build/compressed/fonts/**/*'
  ], { base: 'build/compressed' })
    .pipe(gulp.dest('public/assets'))
    .pipe(revAll())
    .pipe(gulp.dest('public/assets'))
    .pipe(revAll.manifest({ fileName: 'manifest.json' }))
    .pipe(gulp.dest('.'));
});