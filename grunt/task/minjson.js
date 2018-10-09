/* jshint strict:false */

module.exports = {
  "participant": {
    files: [
      {
        expand: true,
        cwd: 'src/translation/',
        src: [
          '*.json'
        ],
        dest: 'dist/translation/'
      }
    ]
  }
}