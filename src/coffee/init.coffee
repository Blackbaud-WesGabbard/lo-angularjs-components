appDependencies = [
  'ui.bootstrap'
  'ngLuminateUtils'
  'luminateControllers'
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
      $dataRoot = jQuery '[data-luminate-root]'
      $rootScope.frId = if $dataRoot.data('fr-id') and not isNaN $dataRoot.data('fr-id') then Number $dataRoot.data('fr-id') else null
  ]

angular.element(document).ready ->
  appModules = [
    'ngLuminateLibrary'
  ]
  angular.bootstrap document, appModules