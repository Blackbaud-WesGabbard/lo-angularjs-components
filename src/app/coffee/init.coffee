appDependencies = [
  'ngSanitize'
  'ngTouch'
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
      rootPath = '../dist/app/'
      libRoot = luminateProperties.ngLibraryRoot
      if libRoot and libRoot isnt ''
        rootPath = libRoot
      rootPath

angular.module 'ngLuminateLibrary'
  .run [
    '$rootScope'
    ($rootScope) ->
      $rootScope.frId = if luminateProperties.frId then luminateProperties.frId else null
      $rootScope.nonSecure = luminateProperties.nonSecure
      $rootScope.secure = luminateProperties.secure
      $rootScope.path = luminateProperties.secure.replace('/site/', '')
  ]

angular.element(document).ready ->
  if not angular.element(document).injector()
    angular.bootstrap document, [
      'ngLuminateLibrary'
    ]
