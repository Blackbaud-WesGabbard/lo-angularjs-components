angular.module 'luminateControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    ($rootScope, $scope) ->
      console.log $rootScope.frId
      $scope.ctrl =
        hide: false
  ]