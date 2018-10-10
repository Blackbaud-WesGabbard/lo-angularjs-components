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
              dollars: amount
              goal: goal
              percent: amount / goal
              hideMeter: hide

          if $scope.progressData
            console.log $scope.progressData, 'test'

          else
            console.log 'no data'
            if $scope.type is 'individual'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + eventId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id
                .then (response) ->
                  if response.data.getParticipantsResponse
                    participant = response.data.getParticipantsResponse.participant
                    $scope.meter =
                      percent: String(Math.round (participant.amountRaised / participant.goal) * 100) + '%'
                      goal: $filter('currency')(participant.goal / 100, '$').replace '.00', ''
                      dollars: $filter('currency')(participant.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace '.00', ''
                      dollarsFormatted: $filter('currency')(participant.amountRaised / 100, '$').replace '.00', ''

            if $scope.type is 'event'
              console.log 'is event'
              TeamraiserEventService.getTeamRaiserData eventId
                .then (response) ->
                  if response.teamraiser
                    teamraiser = response.teamraiser
                    $scope.meter.goal = teamraiser.goal.replace '.00', ''
                    $scope.meter.dollars = teamraiser.dollars.replace '.00', ''

                    rawGoal = Number $scope.meter.goal.replace(/[^\d.]/g,'')
                    rawDollars = Number $scope.meter.dollars.replace(/[^\d.]/g,'')
                    rawPercent = (rawDollars / rawGoal) * 100
                    $scope.meter.percent = String(Math.round (rawDollars / rawGoal) * 100) + '%'
                    if rawPercent < $scope.showMeterPercent
                      $scope.meter.hideMeter = true


      ]
  ]