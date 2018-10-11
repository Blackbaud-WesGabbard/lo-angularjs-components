angular.module 'luminateControllers'
  .directive 'progressMeter', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'dist/html/directive/progressMeter.html'
      scope:
        type: '@'
        showMeterPercent: '@'
        id: '=?'
        frId: '=?'
        progressData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        '$filter'
        'TeamraiserEventService'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        'TeamraiserCompanyService'
        ($rootScope, $scope, $filter, TeamraiserEventService, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) ->
          eventId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.meter =
            goal: 0
            dollars: 0
            percent: 0
            hideMeter: null

          setMeter = (amount, goal) ->
            percent = (amount / goal) * 100
            $scope.meter =
              dollars: $filter('currency')(amount / 100, '$').replace '.00', ''
              goal: $filter('currency')(goal / 100, '$').replace '.00', ''
              percent: String(Math.round (percent)) + '%'
              hideMeter: if percent < $scope.showMeterPercent or percent is Infinity or percent is NaN then true else null

          if $scope.progressData
            percent = $scope.progressData.amount / $scope.progressData.goal
            hideMeter = if percent < $scope.showMeterPercent then true else null
            setMeter $scope.progressData.amount, $scope.progressData.goal, hideMeter
          else
            if $scope.type is 'event'
              TeamraiserEventService.getTeamRaiserData eventId
                .then (response) ->
                  if response.teamraiser
                    teamraiser = response.teamraiser
                    dollars = Number teamraiser.dollars.replace(/[^\d.]/g,'')
                    goal = Number teamraiser.goal.replace(/[^\d.]/g,'')
                    setMeter (dollars * 100), (goal * 100)

            if $scope.type is 'individual'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + eventId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id
                .then (response) ->
                  if response.data.getParticipantsResponse
                    participant = response.data.getParticipantsResponse.participant
                    setMeter Number(participant.amountRaised), Number(participant.goal)

            if $scope.type is 'team'
              TeamraiserTeamService.getTeams 'team_id=' + $scope.id + '&fr_id=' + eventId
                .then (response) ->
                  if response.data.getTeamSearchByInfoResponse
                    team = response.data.getTeamSearchByInfoResponse.team
                    setMeter Number(team.amountRaised), Number(team.goal)

            if $scope.type is 'company'
              TeamraiserCompanyService.getCompanies 'company_id=' + $scope.id + '&fr_id=' + eventId
                .then (response) ->
                  if response.data.getCompaniesResponse
                    company = response.data.getCompaniesResponse.company
                    setMeter company.amountRaised, company.goal



      ]
  ]