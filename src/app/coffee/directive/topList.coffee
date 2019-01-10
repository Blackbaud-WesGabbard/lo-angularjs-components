angular.module 'luminateControllers'
  .directive 'topList', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/topList.html'
      scope:
        type: '@'
        sizeLimit: '@'
        showBadges: '@'
        id: '@'
        frId: '@'
        listData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        'TeamraiserCompanyService'
        ($rootScope, $scope, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) ->
          $scope.frId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.list = 'loading'
          sizeLimit = if $scope.sizeLimit then $scope.sizeLimit else 25

          setList = (list) ->
            $scope.list = list

          if $scope.listData
            $scope.list = $scope.listData
            $scope.$watch 'listData', (value) ->
              setList $scope.listData
          else
            if $scope.type is 'participants'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.frId
                .then (response) ->
                  topList = []
                  topParticipants = response.data.getParticipantsResponse?.participant
                  if topParticipants
                    topParticipants = [topParticipants] if not angular.isArray topParticipants
                    angular.forEach topParticipants, (participant, key) ->
                      if participant.name?.first
                        topList.push participant
                  setList topList
            if $scope.type is 'teams'
              TeamraiserTeamService.getTeams 'team_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.frId
                .then (response) ->
                  setList response.data.getTeamSearchByInfoResponse?.team
            if $scope.type is 'companies'
              TeamraiserCompanyService.getCompanies 'company_name=' + encodeURIComponent('%%%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.frId
                .then (response) ->
                  setList response.data.getCompaniesResponse?.company
      ]
  ]