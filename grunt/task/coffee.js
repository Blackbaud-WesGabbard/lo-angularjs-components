/* jshint strict:false */

module.exports = {
  options: {
    join: true
  },

  "main": {
    files: {
      'dist/app/js/luminate-angularjs-library.js': [
        'src/app/coffee/init.coffee',
        'src/app/coffee/config/*.*',
        'src/app/coffee/service/*.*',
        'src/app/coffee/controller/*.*',
        'src/app/coffee/filter/*.*',
        'src/app/coffee/directive/*.*',
        'src/app/coffee/**/*.*'
      ]
    }
  },

  "documentation": {
    files: {
      'dist/documentation/js/documentation.js': [
        'src/documentation/coffee/init.coffee',
        'src/documentation/coffee/config/*.*',
        'src/coffee/controller/*.*',
        'src/documentation/coffee/**/*.*'
      ]
    }
  }

}