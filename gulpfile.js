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

var config = {
  bowerDir: './bower_components',
  railsEnv: process.env.RAILS_ENV || 'development'
};

gulp.task('default', function() {
  console.log("RAILS_ENV: " + config.railsEnv);
});

/* Clean */
gulp.task('clean', function() {
  del(['./public/assets']);
});

/* Build */
gulp.task('build', [
  'javascript',
  'components-js',
  'publication-js',
  'sass',
  'fonts',
  'images',
  'data'
]);

/* Javascript - Third-party Javascript libraries */
gulp.task('javascript', function() {
  return merge(
    gulp.src([
      config.bowerDir + '/jquery/dist/jquery.js',
      config.bowerDir + '/d3/d3.js',
      config.bowerDir + '/jstz/jstz.js',
      config.bowerDir + '/moment/moment.js'
    ])
  )
    .pipe(concat('library.js'))
    //.pipe(uglify())
    .pipe(gulp.dest('public/assets/js'));
});

/* SASS */
gulp.task('sass', function() {
  gulp.src([
    "app/assets/stylesheets/application.scss",
    "app/assets/stylesheets/publication.scss",
    "app/assets/stylesheets/admin.scss"
  ])
    .pipe(sass({
      outputStyle: 'nested',
      sourceComments: false,
      sourceMap: true,
      includePaths: [
        config.bowerDir + '/bootstrap-sass-official/assets/stylesheets'
      ]
    }))
    .pipe(autoprefixer())
    .pipe(gulp.dest('public/assets/css'));
});

/* Fonts */
gulp.task('fonts', function() {
  gulp.src([
    config.bowerDir + '/bootstrap-sass-official/assets/fonts/bootstrap/*'
  ])
    .pipe(gulp.dest('public/assets/fonts/bootstrap'));
});

/* Images */
gulp.task('images', function() {
  gulp.src([
    './app/assets/images/*'
  ])
    .pipe(gulp.dest('public/assets/images'));
});

/* Data */
gulp.task('data', function() {
  gulp.src([
    './app/assets/text/*'
  ])
    .pipe(gulp.dest('public/assets/text'));
});

/*********************************
* BROWSERIFY - ReactJS components
*********************************/
gulp.task('components-js', function() {
  browserify()
    .transform(reactify)
    .require('react/addons', { expose: 'react/addons' })
    .require('./app/assets/javascripts/components/user_resume_list.jsx', { expose: 'user_resume_list' })
    .require('./app/assets/javascripts/components/resume_form.jsx', { expose: 'resume_form' })
    .require('./app/assets/javascripts/components/user_resume_page.jsx', { expose: 'user_resume_page' })
    .require('./app/assets/javascripts/components/resume_stats_page.jsx', { expose: 'resume_stats_page' })
    .bundle()
    .pipe(source('components.js'))
    //.pipe(buffer())
    //.pipe(uglify())
    .pipe(gulp.dest('public/assets/js'));
});

gulp.task('publication-js', function() {
  browserify([
    './app/assets/javascripts/components/publication_page.jsx'
  ])
    .transform(reactify)
    .require('react/addons', { expose: 'react/addons' })
    .require('./app/assets/javascripts/components/publication_page.jsx', { expose: 'publication_page' })
    .bundle()
    .pipe(source('publication.js'))
    .pipe(gulp.dest('public/assets/js'));
});