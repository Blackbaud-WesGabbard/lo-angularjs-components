angular.module 'luminateControllers'
  .directive 'participationTypes', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'dist/html/directive/participationTypes.html'
      scope:
        frId: '=?'
        layout: '@'
      controller: [
        '$rootScope'
        '$scope'
        'TeamraiserRegistrationService'
        ($rootScope, $scope, TeamraiserRegistrationService) ->
          eventId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.participationOptions =
            participationTypeId: null
          $scope.participationTypes = []
          TeamraiserRegistrationService.getParticipationTypes 'fr_id=' + eventId
            .then (response) ->
              if response.data.getParticipationTypesResponse
                $scope.participationTypes = response.data.getParticipationTypesResponse.participationType
      ]
  ]