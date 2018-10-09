angular.module 'trControllers'
  .directive 'trThermometers', [
    'NG_APP_INFO'
    '$rootScope'
    (NG_APP_INFO, $rootScope) ->
      templateUrl: NG_APP_INFO.rootPath + 'dist/html/directive/trThermometers.html'
      controller: [
        '$rootScope'
        '$scope'
        '$attrs'
        '$uibModal'
        '$filter'
        'NG_APP_INFO'
        'TeamraiserDataService'
        'TeamraiserParticipantService'
        'TeamraiserRegistrationService'
        'TeamraiserTeamService'
        'TeamraiserSuggestionService'
        ($rootScope, $scope, $attrs, $uibModal, $filter, NG_APP_INFO, TeamraiserDataService, TeamraiserParticipantService, TeamraiserRegistrationService, TeamraiserTeamService, TeamraiserSuggestionService) ->
          $scope.path = NG_APP_INFO.rootPath
          $scope.type = $attrs.type
          $scope.attrs = $attrs
          $scope.location = if $attrs.location then $scope.$eval $attrs.location else null

          $scope.thermometer =
            isLoading: true
            goal: 0
            dollars: 0
            dollarsFormatted: 0
            message: null
            prevYear: ''
            prevDollars: 0
            prevTeams: 0
            prevParticipants: 0
            hideTherm: false

          if $attrs.raised and $attrs.goal and $attrs.percent
            $scope.thermometer =
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
            if $attrs.type is 'individual'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + $rootScope.frId + '&list_filter_column=reg.cons_id&list_filter_text=' + $rootScope.consId
                .then (response) ->
                  if response.data.getParticipantsResponse
                    participant = response.data.getParticipantsResponse.participant
                    $scope.thermometer =
                      percent: String(Math.round (participant.amountRaised / participant.goal) * 100) + '%'
                      goal: $filter('currency')(participant.goal / 100, '$').replace '.00', ''
                      dollars: $filter('currency')(participant.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace '.00', ''
                      dollarsFormatted: $filter('currency')(participant.amountRaised / 100, '$').replace '.00', ''

            if $attrs.type is 'event'
              $scope.thermometer.message = 'reus_' + $rootScope.pagenamePrefix + 'thermometer_text'
              TeamraiserDataService.getTeamRaiserData()
                .then (response) ->
                  if response.teamraiser
                    teamraiser = response.teamraiser
                    $scope.thermometer.goal = teamraiser.goal
                    $scope.thermometer.dollars = teamraiser.dollars
                    $scope.thermometer.dollarsFormatted = teamraiser.dollars
                    $scope.thermometer.prevDollars = teamraiser.prevDollars
                    $scope.thermometer.prevParticipants = teamraiser.prevParticipants
                    $scope.thermometer.prevTeams = teamraiser.prevTeams

                    if teamraiser.prevEventDate isnt ''
                      $scope.thermometer.prevYear = teamraiser.prevEventDate.split('/')[2]

                    rawGoal = Number $scope.thermometer.goal.replace(/[^\d.]/g,'')
                    rawDollars = Number $scope.thermometer.dollars.replace(/[^\d.]/g,'')

                    if rawGoal > 0 and rawDollars > 0
                      rawPercent = (rawDollars / rawGoal) * 100
                      $scope.thermometer.percent = String(Math.round (rawDollars / rawGoal) * 100) + '%'
                      if rawPercent < 25 and teamraiser.prevFrId isnt 'Unrecognized type parameter'
                        $scope.thermometer.showPrevYear = true
                    else
                      if teamraiser.prevFrId isnt 'Unrecognized type parameter'
                        $scope.thermometer.showPrevYear = true

                  delete $scope.thermometer.isLoading

          $scope.refreshFundraisingProgress = ->
            TeamraiserParticipantService.getParticipantProgress 'fr_id=' + $rootScope.frId
              .then (response) ->
                participantProgress = response.data.getParticipantProgressResponse.personalProgress
                if ($scope.participantRegistration?.teamId and $scope.participantRegistration?.teamId isnt '-1') or $rootScope.dashboard?.registration?.teamId
                  teamProgress = response.data.getParticipantProgressResponse.teamProgress
                $scope.thermometer.goal = if $scope.type is 'team' then $filter('currency')(Number(teamProgress.goal) / 100, '$').replace '.00', '' else $filter('currency')(Number(participantProgress.goal) / 100, '$').replace '.00', ''
                $scope.thermometer.percent = if $scope.type is 'team' then teamProgress.percent + '%' else participantProgress.percent + '%'
                if not $scope.$$phase
                  $scope.$apply()
                response

          $scope.editGoalOptions =
            updateGoalSuccess: false
            updateGoalFailure: false
            updateGoalFailureMessage: ''
            updateGoalInput: null

          $scope.closeGoalAlerts = (closeModal) ->
            $scope.editGoalOptions.updateGoalSuccess = false
            $scope.editGoalOptions.updateGoalFailure = false
            $scope.editGoalOptions.updateGoalFailureMessage = ''
            if closeModal
              $scope.cancelEditGoal()

          $scope.editGoal = (goalType) ->
            $scope.closeGoalAlerts(false)
            $scope.editGoalOptions.updateGoalInput = null
            $scope.editGoalModal = $uibModal.open
              scope: $scope
              templateUrl: NG_APP_INFO.rootPath + 'dist/html/modal/trpc-edit' + goalType + 'Goal.html'
              size: 'sm'

          $scope.cancelEditGoal = ->
            $scope.editGoalModal.close()

          $scope.updateGoal = (goalType) ->
            switch goalType
              when 'Participant'
                dataStr = 'fr_id=' + $rootScope.frId + '&goal=' + (100 * $scope.editGoalOptions.updateGoalInput).toString()
                TeamraiserRegistrationService.updateRegistration dataStr
                  .then (response) ->
                    if response.data.errorResponse
                      $scope.editGoalOptions.updateGoalFailure = true
                      if response.data.errorResponse.message
                        $scope.editGoalOptions.updateGoalFailureMessage = response.data.errorResponse.message
                      else
                        $scope.editGoalOptions.updateGoalFailureMessage = 'An unexpected error occurred.'
                    else
                      $scope.editGoalOptions.updateGoalSuccess = true
                      $scope.refreshFundraisingProgress()
                      $scope.closeGoalAlerts(true)
                      if $rootScope.facebookFundraiserConfig?.fundraiserId
                        FacebookFundraiserService.updateFundraiser()
                          .then ->
                            FacebookFundraiserService.syncDonations()
                    response
              when 'Team'
                dataStr = 'team_goal=' + (100 * $scope.editGoalOptions.updateGoalInput).toString()
                TeamraiserTeamService.updateTeamInformation dataStr
                  .then (response) ->
                    if response.data.errorResponse
                      $scope.editGoalOptions.updateGoalFailure = true
                      if response.data.errorResponse.message
                        $scope.editGoalOptions.updateGoalFailureMessage = response.data.errorResponse.message
                      else
                        $scope.editGoalOptions.updateGoalFailureMessage = 'An unexpected error occurred.'
                    else
                      $scope.editGoalOptions.updateGoalSuccess = true
                      $scope.refreshFundraisingProgress()
                      $scope.closeGoalAlerts(true)
                      TeamraiserSuggestionService.dismissSuggestion 'RaiseTeamGoal'
                    response
      ]
  ]