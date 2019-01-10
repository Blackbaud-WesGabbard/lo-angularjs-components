angular.module 'luminateControllers'
  .directive 'loginForm', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/loginForm.html'
      scope:
        layout: '@'
        showLables: '@'
        formSize: '@'
      controller: [
        '$scope'
        '$httpParamSerializer'
        'AuthService'
        ($scope, $httpParamSerializer, AuthService) ->
          $scope.state =
            errorMsg: null
          $scope.layout = if $scope.layout then $scope.layout else 'vertical'
          $scope.showLables = if $scope.showLables then $scope.showLables else true

          $scope.loginUser = ->
            if $scope.loginForm.$valid
              AuthService.login $httpParamSerializer($scope.loginUser)
                .then (response) ->
                  if response.data.errorResponse
                    $scope.state.errorMsg = response.data.errorResponse.message
                  else if response.data.loginResponse
                    location.reload();


      ]
  ]