angular.module 'luminateControllers'
  .directive 'progressBadges', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/progressBadges.html'
      scope:
        frId: '@'
        type: '@'
        id: '@'
        customBadgeData: '=?'
      controller: [
        '$scope'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        ($scope, TeamraiserParticipantService, TeamraiserTeamService) ->
          $scope.frId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.badges =
            defaultBadges: []
            customBadges: []

          if $scope.customBadgeData
            $scope.badges.customBadges = $scope.customBadges
            $scope.$watch 'customBadgeData', (value) ->
              $scope.badges.customBadges = value
          else
            if $scope.type is 'individual'
              TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + $scope.frId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id
                .then (response) ->
                  $scope.badges.defaultBadges = [response.data.getParticipantsResponse?.participant.badges]
                  if $scope.badges.defaultBadges[0].participantMilestoneLargeBadgeUrl
                    $scope.badges.defaultBadges[0].participantMilestoneLargeBadgeUrl = $scope.badges.defaultBadges[0].participantMilestoneLargeBadgeUrl.replace '/lg_', '/'
                  if $scope.badges.defaultBadges[0].personalDonationBadgeLargeUrl
                    $scope.badges.defaultBadges[0].personalDonationBadgeLargeUrl = $scope.badges.defaultBadges[0].personalDonationBadgeLargeUrl.replace '/lg_', '/'

            if $scope.type is 'team'
              TeamraiserTeamService.getTeams 'team_id=' + $scope.id + '&fr_id=' + $scope.frId
                .then (response) ->
                  $scope.badges.defaultBadges = [response.data.getTeamSearchByInfoResponse?.team.badges]

      ]
  ]