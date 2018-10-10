angular.module 'luminateControllers'
  .directive 'progressMeter', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'dist/html/directive/progressMeter.html'
      scope:
        type: '@'
        hideMeter: '='
      controller: [
        '$rootScope'
        '$scope'
        '$attrs'
        '$filter'
        'APP_INFO'
        'TeamraiserDataService'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        ($rootScope, $scope, $attrs, $filter, APP_INFO, TeamraiserDataService, TeamraiserParticipantService, TeamraiserTeamService) ->
          $scope.attrs = $attrs
          $scope.location = if $attrs.location then $scope.$eval $attrs.location else null
          console.log $scope

          $scope.meter =
            goal: 0
            dollars: 0
            percent: 0
            hideMeter: null

          if $attrs.raised and $attrs.goal and $attrs.percent
            $scope.meter =
              goal: $filter('currency')(Number($scope.$eval($attrs.goal)) / 100, '$').replace '.00', ''
              dollars: $filter('currency')(Number($scope.$eval($attrs.raised)) / 100, '$').replace('$', '').replace(/,/g, '').replace '.00', ''
              dollarsFormatted: $filter('currency')(Number($scope.$eval($attrs.raised)) / 100, '$').replace '.00', ''
              percent: $scope.$eval($attrs.percent) + '%'
              rank: $scope.$eval $attrs.rank
              total: $scope.$eval $attrs.total
              daysLeft: $scope.$eval $attrs.daysLeft
              teamMembers: $scope.$eval $attrs.teamMembers
              teamCount: $scope.$eval $attrs.teamCount
              participantCount: $scope.$eval $attrs.participantCount
              hideTherm: if $scope.$eval($attrs.hideTherm) is '0' then true else false
          else
            if $scope.type is 'individual'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + $rootScope.frId + '&list_filter_column=reg.cons_id&list_filter_text=' + $rootScope.consId
                .then (response) ->
                  if response.data.getParticipantsResponse
                    participant = response.data.getParticipantsResponse.participant
                    $scope.meter =
                      percent: String(Math.round (participant.amountRaised / participant.goal) * 100) + '%'
                      goal: $filter('currency')(participant.goal / 100, '$').replace '.00', ''
                      dollars: $filter('currency')(participant.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace '.00', ''
                      dollarsFormatted: $filter('currency')(participant.amountRaised / 100, '$').replace '.00', ''

            if $scope.type is 'event'
              TeamraiserDataService.getTeamRaiserData()
                .then (response) ->
                  if response.teamraiser
                    teamraiser = response.teamraiser
                    $scope.meter.goal = teamraiser.goal.replace '.00', ''
                    $scope.meter.dollars = teamraiser.dollars.replace '.00', ''
                    $scope.meter.prevDollars = teamraiser.prevDollars.replace '.00', ''
                    $scope.meter.prevParticipants = teamraiser.prevParticipants
                    $scope.meter.prevTeams = teamraiser.prevTeams

                    if teamraiser.prevEventDate isnt ''
                      $scope.meter.prevYear = teamraiser.prevEventDate.split('/')[2]

                    rawGoal = Number $scope.meter.goal.replace(/[^\d.]/g,'')
                    rawDollars = Number $scope.meter.dollars.replace(/[^\d.]/g,'')
                    rawPercent = (rawDollars / rawGoal) * 100
                    $scope.meter.percent = String(Math.round (rawDollars / rawGoal) * 100) + '%'
                    if rawPercent < $scope.hideMeter
                      $scope.meter.hideMeter = true

                    console.log $scope.meter

          $scope.refreshFundraisingProgress = ->
            TeamraiserParticipantService.getParticipantProgress 'fr_id=' + $rootScope.frId
              .then (response) ->
                participantProgress = response.data.getParticipantProgressResponse.personalProgress
                if ($scope.participantRegistration?.teamId and $scope.participantRegistration?.teamId isnt '-1') or $rootScope.dashboard?.registration?.teamId
                  teamProgress = response.data.getParticipantProgressResponse.teamProgress
                $scope.meter.goal = if $scope.type is 'team' then $filter('currency')(Number(teamProgress.goal) / 100, '$').replace '.00', '' else $filter('currency')(Number(participantProgress.goal) / 100, '$').replace '.00', ''
                $scope.meter.percent = if $scope.type is 'team' then teamProgress.percent + '%' else participantProgress.percent + '%'
                if not $scope.$$phase
                  $scope.$apply()
                response








      ]
  ]