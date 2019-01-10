/* jshint strict:false */

require('events').EventEmitter.prototype._maxListeners = 100;

module.exports = {
  "grunt-config": {
    files: [
      'Gruntfile.coffee',
      'grunt/task/*.js',
      'grunt/.jshintrc'
    ],
    tasks: [
      'jshint:grunt-config',
      'notify:grunt-config'
    ]
  },

  "main": {
    files: [
      'src/app/html/**/*',
      'src/app/sass/**/*',
      'src/app/sass/main.scss',
      'src/app/coffee/**/*'
    ],
    tasks: [
      'clean:main',
      'css-dist:main',
      'js-dist:main',
      'html-dist:main',
      'notify:main'
    ]
  },

  "documentation": {
    files: [
      'src/documentation/html/**/*',
      'src/documentation/coffee/**/*',
      'src/documentation/sass/**/*',
      'src/documentation/sass/main.scss'
    ],
    tasks: [
      'clean:documentation',
      'css-dist:documentation',
      'js-dist:documentation',
      'html-dist:documentation',
      'notify:documentation'
    ]
  }
}