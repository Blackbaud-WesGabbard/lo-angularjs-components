appDependencies = [
  'ngRoute'
  'ngLuminateUtils'
  'ngSanitize'
  'documentationControllers'
]

angular.module 'ngLuminateDocumentation', appDependencies

angular.module 'documentationControllers', []

angular.module 'ngLuminateDocumentation'
  .constant 'DOC_INFO',
    version: '1.0.0'
    rootPath: do ->
      rootPath = rootPath = '../dist/documentation/'
      rootPath

angular.element(document).ready ->
  appModules = [
    'ngLuminateDocumentation'
  ]

  try
    angular.module 'ngLuminateLibrary'
    appModules.push 'ngLuminateLibrary'
  catch error

  angular.bootstrap document, appModules



