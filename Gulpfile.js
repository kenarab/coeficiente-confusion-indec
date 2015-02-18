"use strict";

var t = new Date().getTime()
var js_all = 'js/all.min.js';
var js_vendor = 'js/vendor.min.js';

var gulp = require('gulp'),
    jshint = require('gulp-jshint'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
	build = require('gulp-build'),
	minifyCSS = require('gulp-minify-css'),
	sourcemaps = require('gulp-sourcemaps'),
	clean = require('gulp-clean'),
	htmlreplace = require('gulp-html-replace'),
	stylish = require('jshint-stylish');


gulp.task('clean_all', function () {
    gulp.src('build/*')
        .pipe(clean({force: true}));
});


gulp.task('copy', function () {
	
	gulp.src('**/*.html', { cwd: 'app' })
		.pipe(htmlreplace({
			js:[js_vendor+'?'+t, js_all+'?'+t],
			css: ['css/all.min.css?'+t]
		}))
		.pipe(gulp.dest('build'));
	
	gulp.src('data/**/*', { cwd: 'app' })
		.pipe(gulp.dest('build/data'));
});

gulp.task('minify-css', function () {

	gulp.src(['css/reset.css', 'bower_components/c3/c3.min.css', 'css/styles.css'], { cwd: 'app' })
    .pipe(minifyCSS())
    .pipe(concat('all.min.css'))
    .pipe(gulp.dest('build/css'));
	
});


gulp.task('js', function () {
	gulp.src('js/*.js', { cwd: 'app' })
      .pipe(jshint())
      // .pipe(jshint.reporter('default'))
      .pipe(jshint.reporter(stylish))
      .pipe(uglify())
      .pipe(concat(js_all))
      .pipe(gulp.dest('build'));
	
	gulp.src('bower_components/**/*.min.js', { cwd: 'app' })
      .pipe(uglify())
      .pipe(concat(js_vendor))
      .pipe(gulp.dest('build'));
	
});

gulp.task('default', ['copy', 'js', 'minify-css']);

gulp.task('build', ['js', 'minify-css']);


