angular.module 'luminateControllers'
  .directive 'participationTypes', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'dist/html/directive/participationTypes.html'
      scope:
        frId: '@'
        layout: '@'
        isClickable: '@'
      controller: [
        '$rootScope'
        '$scope'
        'TeamraiserRegistrationService'
        ($rootScope, $scope, TeamraiserRegistrationService) ->
          $scope.participationOptions =
            participationTypeId: null
          $scope.participationTypes = []
          TeamraiserRegistrationService.getParticipationTypes()
            .then (response) ->
              if response.data.getParticipationTypesResponse
                $scope.participationTypes = response.data.getParticipationTypesResponse.participationType
      ]
  ]