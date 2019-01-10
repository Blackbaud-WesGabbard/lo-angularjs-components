/* jshint strict:false */

module.exports = {
  "ng-utils": {
    files: [
      {
        expand: true,
        cwd: 'node_modules/angular-luminate-utils/dist/js/',
        src: '*.js',
        dest: 'dist/vendor/js/'
      }
    ]
  },
  "ng-bootstrap": {
    files: [
      {
        expand: true,
        cwd: 'node_modules/angular-ui-bootstrap/dist/',
        src: '*.js',
        dest: 'dist/vendor/js/'
      }
    ]
  }
}