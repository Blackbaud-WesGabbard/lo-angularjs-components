angular.module 'luminateControllers'
  .directive 'topList', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'dist/html/directive/topList.html'
      scope:
        type: '@'
        sizeLimit: '@'
        showBadges: '@'
        id: '=?'
        frId: '=?'
        listData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        '$filter'
        'TeamraiserEventService'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        'TeamraiserCompanyService'
        ($rootScope, $scope, $filter, TeamraiserEventService, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) ->
          $scope.eventId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.list = {}
          sizeLimit = if $scope.sizeLimit then $scope.sizeLimit else 500
          if $scope.listData
            console.log listData
          else
            if $scope.type is 'participants'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.eventId
                .then (response) ->
                  if response.data.getParticipantsResponse
                    $scope.list = response.data.getParticipantsResponse.participant
            if $scope.type is 'teams'
              TeamraiserTeamService.getTeams 'team_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.eventId
                .then (response) ->
                  if response.data.getTeamSearchByInfoResponse
                    $scope.list = response.data.getTeamSearchByInfoResponse.team
            if $scope.type is 'companies'
              TeamraiserCompanyService.getCompanies 'company_name=' + encodeURIComponent('%%%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.eventId
                .then (response) ->
                  if response.data.getCompaniesResponse
                    $scope.list = response.data.getCompaniesResponse.company

      ]
  ]