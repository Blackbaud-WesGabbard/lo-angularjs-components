angular.module 'luminateControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    ($rootScope, $scope) ->
      console.log $rootScope.frId
      $scope.ctrl =
        hide: false
        frId: 1070
        consId: 1001491
  ]