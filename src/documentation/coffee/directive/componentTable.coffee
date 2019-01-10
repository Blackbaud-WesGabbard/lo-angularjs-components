angular.module 'documentationControllers'
  .directive 'componentTable', [
    'DOC_INFO'
    '$rootScope'
    (DOC_INFO, $rootScope) ->
      templateUrl: DOC_INFO.rootPath + 'html/directive/componentTable.html'
      scope:
        component: '@'
      controller: [
        '$rootScope'
        '$scope'
        ($rootScope, $scope) ->
          $scope.selectedComponent = $rootScope.components[$scope.component]
      ]
  ]