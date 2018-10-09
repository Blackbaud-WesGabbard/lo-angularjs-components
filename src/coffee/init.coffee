appDependencies = [
  'luminateControllers'
  'ui.bootstrap'
  'ngLuminateUtils'
]

angular.module 'ngLuminateLibrary', appDependencies

angular.module 'luminateControllers', []

angular.module 'ngLuminateLibrary'
  .constant 'APP_INFO',
    version: '1.0.0'
    rootPath: do ->
      rootPath = '/'
      rootPath

angular.module 'ngLuminateLibrary'
  .run [
    '$rootScope'
    ($rootScope) ->
      #$dataRoot = jQuery '[data-luminate-root]'
      #console.log $dataRoot
      $rootScope.frId = 29300
  ]