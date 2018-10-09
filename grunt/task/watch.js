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
      'src/html/**/*',
      'src/sass/**/*',
      'src/coffee/**/*'
    ],
    tasks: [
      'clean:main',
      'css-dist:main',
      'js-dist:main',
      'html-dist:main',
      'notify:main'
    ]
  }
}