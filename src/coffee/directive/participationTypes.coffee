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
          $scope.selectedParticipationType =
            id: null
            rawAmount: null
          $scope.participationTypes = []

          $scope.selectParticipation = (type) ->
            $scope.selectedParticipationType =
              id: type.id
              rawAmount: type.rawAmount

          TeamraiserRegistrationService.getParticipationTypes 'fr_id=' + eventId
            .then (response) ->
              if response.data.getParticipationTypesResponse
                $scope.participationTypes = response.data.getParticipationTypesResponse.participationType
      ]
  ]