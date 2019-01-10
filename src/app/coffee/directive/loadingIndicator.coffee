angular.module 'luminateControllers'
  .directive 'loadingIndicator', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/loadingIndicator.html'
      replace: true
      scope:
        size: '@'
        text: '@'
      controller: [
        '$scope'
        ($scope) ->
          $scope.size = if $scope.size then $scope.size else 4
      ]
  ]