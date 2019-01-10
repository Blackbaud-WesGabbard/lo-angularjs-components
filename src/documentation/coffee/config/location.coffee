angular.module 'ngLuminateDocumentation'
  .config [
    '$locationProvider'
    ($locationProvider) ->
      $locationProvider.hashPrefix ''
  ]