/* jshint strict:false */

module.exports = {
  options: {
    join: true
  },

  "main": {
    files: {
      'dist/js/main.js': [
        'src/coffee/init.coffee',
        'src/coffee/config/*.*',
        'src/coffee/service/*.*',
        'src/coffee/filter/*.*',
        'src/coffee/directive/*.*',
        'src/coffee/**/*.*'
      ]
    }
  }
}