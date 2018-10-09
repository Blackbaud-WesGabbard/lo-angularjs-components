angular.module 'luminateControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    '$location'
    ($rootScope, $scope, $location) ->
      console.log 'main ctrl'
      $rootScope.$location = $location
      $rootScope.baseUrl = $location.absUrl().split('#')[0]
  ]