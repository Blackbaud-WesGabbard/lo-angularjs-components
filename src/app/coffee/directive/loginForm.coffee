angular.module 'luminateControllers'
  .directive 'loginForm', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/loginForm.html'
      scope:
        layout: '@'
        showLables: '@'
        formSize: '@'
        buttonText: '@'
        passwordResetEmail: '@'
        rememberMe: '@'
      controller: [
        '$scope'
        '$httpParamSerializer'
        'AuthService'
        ($scope, $httpParamSerializer, AuthService) ->
          $scope.layout = if $scope.layout then $scope.layout else 'vertical'
          $scope.showLables = if $scope.showLables then $scope.showLables else true
          $scope.buttonText = if $scope.buttonText then $scope.buttonText else 'Login'
          $scope.randomNumber = Math.random().toString(36).substr(2, 5);

          $scope.loginUser = ->
            if $scope.loginForm.$valid
              $scope.state =
                errorMsg: null
                successMsg: null
              AuthService.login $httpParamSerializer($scope.loginUser)
                .then (response) ->
                  if response.data.errorResponse
                    $scope.state.errorMsg = response.data.errorResponse.message
                  else if response.data.loginResponse
                    $scope.state.successMsg = 'You are now logged in as ' + $scope.loginUser.user_name
                    $scope.$emit 'loginResponse', response.data.loginResponse
            else
              $scope.state.errorMsg = 'Please supply a valid email address and password'

      ]
  ]
