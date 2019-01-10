/* jshint strict:false */

module.exports = {
  options: {
    noAdvanced: true
  },

  "main": {
    files: [
      {
        src: 'dist/app/css/luminate-angularjs-library.css',
        dest: 'dist/app/css/luminate-angularjs-library.min.css'
      }
    ]
  },
  "documentation": {
    files: [
      {
        src: 'dist/documentation/css/main.css',
        dest: 'dist/documentation/css/main.min.css'
      }
    ]
  }
}