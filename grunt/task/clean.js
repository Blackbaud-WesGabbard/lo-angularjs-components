/* jshint strict:false */

module.exports = {
  "main": {
    files: [
      {
        expand: true,
        cwd: 'dist/css/',
        src: [
          '**/*'
        ]
      },
      {
        expand: true,
        cwd: 'dist/js/',
        src: [
          '**/*'
        ]
      },
      {
        expand: true,
        cwd: 'dist/html/',
        src: [
          '**/*.html'
        ]
      }
    ]
  }
}