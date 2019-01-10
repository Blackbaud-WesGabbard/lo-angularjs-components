/* jshint strict:false */

module.exports = {
  options: {
    collapseBooleanAttributes: true,
    collapseWhitespace: true,
    minifyCSS: true,
    minifyJS: true,
    removeComments: true,
    removeEmptyAttributes: true,
    removeScriptTypeAttributes: true,
    removeStyleLinkTypeAttributes: true
  },

  "main": {
    files: [
      {
        cwd: 'src/app/html/',
        expand: true,
        src: [
          '**/*.html'
        ],
        dest: 'dist/app/html/'
      }
    ]
  },

  "documentation": {
    files: [
      {
        cwd: 'src/documentation/html/',
        expand: true,
        src: [
          '**/*.html'
        ],
        dest: 'dist/documentation/html/'
      }
    ]
  }
}