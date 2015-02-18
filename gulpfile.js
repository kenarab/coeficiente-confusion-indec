'use strict';

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
	htmlreplace = require('gulp-html-replace');


gulp.task('clean_all', function () {
    return gulp.src('build')
        .pipe(clean({force: true}));
});


gulp.task('copy', function () {
	
	gulp.src('app/**/*.html')
		.pipe(htmlreplace({
			js:[js_vendor+'?'+t, js_all+'?'+t],
			css: ['css/all.min.css?'+t]
		}))
		.pipe(gulp.dest('build'));
	
	gulp.src('app/data/*')
		.pipe(gulp.dest('build/data'));
});

gulp.task('minify-css', function () {

	gulp.src(['app/css/reset.css', 'bower_components/c3/c3.min.css', 'app/css/styles.css'])
	// .pipe(sourcemaps.init())
    .pipe(minifyCSS())
    .pipe(concat('all.min.css'))
    // .pipe(sourcemaps.write())
    .pipe(gulp.dest('build/css'));
	
});


gulp.task('js', function () {
	gulp.src('app/js/*.js')
      .pipe(jshint())
      .pipe(jshint.reporter('default'))
      .pipe(uglify())
      .pipe(concat(js_all))
      .pipe(gulp.dest('build'));
	
	gulp.src('bower_components/**/*.min.js')
      .pipe(uglify())
      .pipe(concat(js_vendor))
      .pipe(gulp.dest('build'));
	
});



gulp.task('build', ['clean_all', 'js', 'minify-css', 'copy']);
