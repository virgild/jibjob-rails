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
  return gulp.src([
    config.bowerDir + '/jquery/dist/jquery.js',
    config.bowerDir + '/d3/d3.js',
    config.bowerDir + '/jstz/jstz.js',
    config.bowerDir + '/moment/moment.js'
  ])
    .pipe(concat('library.js'))
    .pipe(gulp.dest('build/js'));
});

/* Javascript - App */
gulp.task('javascript-app', function() {
  return browserify()
    .require('./app/assets/javascripts/signup.js', { expose: 'signup' })
    .bundle()
    .pipe(source('app.js'))
    .pipe(gulp.dest('build/js'));
});

/* SASS */
gulp.task('sass', function() {
  return gulp.src([
    "app/assets/stylesheets/application.scss",
    "app/assets/stylesheets/publication.scss",
    "app/assets/stylesheets/admin.scss"
  ])
    .pipe(sass({
      outputStyle: 'nested',
      sourceComments: true,
      sourceMap: false,
      includePaths: [
        config.bowerDir + '/bootstrap-sass-official/assets/stylesheets'
      ]
    }))
    .pipe(autoprefixer())
    .pipe(gulp.dest('build/css'));
});

/* Fonts */
gulp.task('fonts', function() {
  return gulp.src([
    config.bowerDir + '/bootstrap-sass-official/assets/fonts/bootstrap/*'
  ])
    .pipe(gulp.dest('build/fonts/bootstrap'));
});

/* Images */
gulp.task('images', function() {
  return gulp.src([
    './app/assets/images/*'
  ])
    .pipe(gulp.dest('build/images'));
});

/* Data */
gulp.task('data', function() {
  return gulp.src([
    './app/assets/text/*'
  ])
    .pipe(gulp.dest('build/text'));
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
    .pipe(gulp.dest('build/js'));
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
    .pipe(gulp.dest('build/js'));
});

/* Manifest */
gulp.task('manifest', ['install'], function() {
  return gulp.src([
    'build/css/*.css',
    'build/js/*.js',
    'build/images/**/*',
    'build/fonts/**/*'
  ], { base: 'build' })
    .pipe(gulp.dest('public/assets'))
    .pipe(revAll())
    .pipe(gulp.dest('public/assets'))
    .pipe(revAll.manifest({ fileName: 'manifest.json' }))
    .pipe(gulp.dest('.'));
});

gulp.task('install', ['build'], function() {
  return gulp.src('build/**/*')
    .pipe(gulp.dest('public/assets'));
});