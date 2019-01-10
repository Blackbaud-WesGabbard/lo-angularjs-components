angular.module 'luminateControllers'
  .directive 'participationTypes', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/participationTypes.html'
      scope:
        frId: '@'
        layout: '@'
        participationTypesData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        'TeamraiserRegistrationService'
        ($rootScope, $scope, TeamraiserRegistrationService) ->
          $scope.frId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.state =
            selectedParticipationType: null
          $scope.participationTypes = 'loading'

          setPartType = (types) ->
            $scope.participationTypes = types

          if $scope.participationTypesData
            setPartType $scope.participationTypesData
            $scope.$watch 'participationTypesData', (value) ->
              setPartType $scope.participationTypesData
          else
            TeamraiserRegistrationService.getParticipationTypes 'fr_id=' + $scope.frId
              .then (response) ->
                if response.data.getParticipationTypesResponse
                  setPartType response.data.getParticipationTypesResponse.participationType
      ]
  ]