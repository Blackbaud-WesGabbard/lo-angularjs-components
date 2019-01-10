/* jshint strict:false */

module.exports = {
  "main": {
    files: [
      {
        expand: true,
        cwd: 'dist/app/css/',
        src: [
          '**/*'
        ]
      },
      {
        expand: true,
        cwd: 'dist/app/js/',
        src: [
          '**/*'
        ]
      },
      {
        expand: true,
        cwd: 'dist/app/html/',
        src: [
          '**/*.html'
        ]
      }
    ]
  },

  "documentation": {
    files: [
      {
        expand: true,
        cwd: 'dist/documentation/js/',
        src: [
          '**/*'
        ]
      },
      {
        expand: true,
        cwd: 'dist/documentation/html/',
        src: [
          '**/*.html'
        ]
      }
    ]
  }

}