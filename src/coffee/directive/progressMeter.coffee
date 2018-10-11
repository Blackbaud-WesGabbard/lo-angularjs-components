angular.module 'luminateControllers'
  .directive 'progressMeter', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'dist/html/directive/progressMeter.html'
      scope:
        type: '@'
        showMeterPercent: '='
        id: '@'
        frId: '@'
        progressData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        '$filter'
        'APP_INFO'
        'TeamraiserEventService'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        ($rootScope, $scope, $filter, APP_INFO, TeamraiserEventService, TeamraiserParticipantService, TeamraiserTeamService) ->
          eventId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.meter =
            goal: 0
            dollars: 0
            percent: 0
            hideMeter: null

          setMeter = (amount, goal, hide) ->
            $scope.meter =
              dollars: $filter('currency')(amount / 100, '$').replace '.00', ''
              goal: $filter('currency')(goal / 100, '$').replace '.00', ''
              percent: String(Math.round (amount / goal) * 100) + '%'
              hideMeter: hide

          if $scope.progressData
            percent = $scope.progressData.amount / $scope.progressData.goal
            hideMeter = if percent < $scope.showMeterPercent then true else null
            setMeter $scope.progressData.amount, $scope.progressData.goal, hideMeter
          else
            if $scope.type is 'individual'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + eventId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id
                .then (response) ->
                  if response.data.getParticipantsResponse
                    participant = response.data.getParticipantsResponse.participant
                    dollars = Number participant.amountRaised
                    goal = Number participant.goal
                    percent = dollars / goal
                    hideMeter = if percent < $scope.showMeterPercent then true else null
                    setMeter dollars, goal, hideMeter

            if $scope.type is 'event'
              TeamraiserEventService.getTeamRaiserData eventId
                .then (response) ->
                  if response.teamraiser
                    teamraiser = response.teamraiser
                    dollars = Number teamraiser.dollars.replace(/[^\d.]/g,'')
                    goal = Number teamraiser.goal.replace(/[^\d.]/g,'')
                    percent = (dollars / goal) * 100
                    hideMeter = if percent < $scope.showMeterPercent then true else null
                    setMeter (dollars * 100), (goal * 100), hideMeter


      ]
  ]