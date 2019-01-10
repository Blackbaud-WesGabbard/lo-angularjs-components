angular.module 'luminateControllers'
  .directive 'passwordReset', [
    'APP_INFO'
    (APP_INFO) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/passwordReset.html'
      scope:
        email: '@'
        type: '@'
        size: '@'
      controller: [
        '$scope'
        'AuthService'
        ($scope, AuthService) ->
          $scope.type = if $scope.type then $scope.type else 'link'
          $scope.size = if $scope.size then $scope.size else 'md'
          $scope.state =
            sendLogin: false
            error: null
          $scope.forgotLogin = ->
            if $scope.email
              AuthService.login 'email=' + $scope.email + '&send_user_name=true'
                .then (response) ->
                  $scope.state.sendLogin = true
            else
              $scope.state.error = true
      ]
  ]
