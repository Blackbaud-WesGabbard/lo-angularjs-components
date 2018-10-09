appDependencies = [
  'ngSanitize'
  'ngTouch'
  'ngAria'
  'ui.bootstrap'
  'ngLuminateUtils'
  'trControllers'
]

angular.forEach ['textAngular'], (appDependency) ->
  try
    angular.module appDependency
    appDependencies.push appDependency
  catch error

angular.module 'loComponents', appDependencies

angular.module 'loControllers', []

angular.module 'loComponents'
  .constant 'APP_INFO',
    version: '1.0.0'
    rootPath: do ->
      rootPath = '/'
      rootPath

angular.module 'loComponents'
  .run [
    '$rootScope'
    ($rootScope) ->
      $dataRoot = angular.element '[data-root]'
      $rootScope.frId = if $dataRoot.data('fr-id') and not isNaN $dataRoot.data('fr-id') then Number $dataRoot.data('fr-id') else null
      $rootScope.secureDomain = $dataRoot.data('secure-domain') if $dataRoot.data('secure-domain') isnt ''
      $rootScope.apiKey = $dataRoot.data('api-key') if $dataRoot.data('api-key') isnt ''
      $rootScope.authToken = $dataRoot.data('auth-token') if $dataRoot.data('auth-token') isnt ''
      $rootScope.consId = $dataRoot.data('cons-id') if $dataRoot.data('cons-id') isnt ''
      $rootScope.firstName = $dataRoot.data('first-name') if $dataRoot.data('first-name') isnt ''
      $rootScope.lastName = $dataRoot.data('last-name') if $dataRoot.data('last-name') isnt ''
      $rootScope.partTeamId = $dataRoot.data('team-id') if $dataRoot.data('team-id') isnt ''
      $rootScope.partTypeId = $dataRoot.data('part-type-id') if $dataRoot.data('part-type-id') isnt ''
      $rootScope.sessionCookie = $dataRoot.data('session-cookie') if $dataRoot.data('session-cookie') isnt ''
      $rootScope.tablePrefix = $dataRoot.data('table-prefix') if $dataRoot.data('table-prefix') isnt ''
  ]

angular.element(document).ready ->
  appModules = [
    'loComponents'
  ]
  angular.bootstrap document, appModules