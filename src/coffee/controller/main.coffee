angular.module 'luminateControllers'
  .controller 'MainCtrl', [
    '$scope'
    ($scope) ->
      $scope.ctrl =
        hide: false
        frId: 1070
        consId: 1001491
        teamId: 1057
        companyId: 1013
        amount: 56500
        goal: 140000
  ]