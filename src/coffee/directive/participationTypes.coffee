angular.module 'luminateControllers'
  .directive 'progressMeter', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'dist/html/directive/participationTypes.html'
      scope:
        type: '@'
        showMeterPercent: '@'
        id: '=?'
        frId: '=?'
        progressData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        'TeamraiserRegistrationService'
        ($rootScope, $scope, TeamraiserRegistrationService) ->
          $scope.participationTypes = []
          TeamraiserRegistrationService.getParticipationTypes()
            .then (response) ->
              if response.data.getParticipationTypesResponse
                $scope.participationTypes = response.data.getParticipationTypesResponse.participationType
                angular.forEach $scope.participationTypes, (type) ->
                  formatStr = type.description.replace(/(\r\n\t|\n|\r\t)/gm,"").trim()
                  type.description = formatStr.replace(/\|/g, '<br />')

      ]
  ]