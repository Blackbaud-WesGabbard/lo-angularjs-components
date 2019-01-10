/* jshint strict:false */

const sass = require('node-sass')

module.exports = {
  options: {
    implementation: sass
  },
  "main": {
    files: {
      'dist/app/css/luminate-angularjs-library.css': [
        'src/app/sass/main.scss'
      ]
    }
  },

  "documentation": {
    files: {
      'dist/documentation/css/main.css': [
        'src/documentation/sass/main.scss'
      ]
    }
  }

}
