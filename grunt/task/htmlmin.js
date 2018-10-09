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
        cwd: 'src/html/',
        expand: true,
        src: [
          '**/*.html'
        ],
        dest: 'dist/html/'
      }
    ]
  }
}