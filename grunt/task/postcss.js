/* jshint strict:false */

module.exports = {
  options: {
    processors: [
      require('autoprefixer')({
        browsers: [
          'last 2 versions',
          'ie >= 10',
          'Safari >= 7',
          'ios_saf >= 7'
        ]
      })
    ]
  },

  "main": {
    files: [
      {
        expand: true,
        cwd: 'dist/app/css/',
        src: [
          'main.css'
        ],
        dest: 'dist/app/css/'
      }
    ]
  },

  "documentation": {
    files: [
      {
        expand: true,
        cwd: 'dist/documentation/css/',
        src: [
          'main.css'
        ],
        dest: 'dist/documentation/css/'
      }
    ]
  }
}