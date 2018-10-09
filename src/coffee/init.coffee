appDependencies = [
  'luminateControllers'
  'ui.bootstrap'
]

angular.module 'ngLuminateLibrary', appDependencies

angular.module 'luminateControllers', []

angular.module 'ngLuminateLibrary'
  .constant 'APP_INFO',
    version: '1.0.0'
    rootPath: do ->
      rootPath = '/'
      rootPath