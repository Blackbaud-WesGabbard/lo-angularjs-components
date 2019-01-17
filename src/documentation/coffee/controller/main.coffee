angular.module 'documentationControllers'
  .controller 'MainCtrl', [
    '$rootScope'
    '$scope'
    'TeamraiserParticipantService'
    'TeamraiserEventService'
    'TeamraiserRegistrationService'
    'loComponentsService'
    ($rootScope, $scope, TeamraiserParticipantService, TeamraiserEventService, TeamraiserRegistrationService, loComponentsService) ->
      $scope.state =
        subNav: null
      $scope.ctrl =
        hide: false
        frId: 1070
        consId: 1001491
        teamId: 1057
        companyId: 1013
        amount: 56500
        goal: 140000
      $scope.topList = []
      $scope.donorList = [
        {
          'name': 'Wes Gabbard'
          'amountRaised': '$250.00'
        },
        {
          'name': 'Starlee Gabbard'
          'amountRaised': '$200.00'
        },
        {
          'name': 'Ziggy Hildebrand'
          'amountRaised': '$175.00'
        },
        {
          'name': 'Kathleen Hildebrand'
          'amountRaised': '$100.00'
        },
        {
          'name': 'Sneak E Pete'
          'amountRaised': '$75.00'
        },
        {
          'name': 'Calamity Jane'
          'amountRaised': '$50.00'
        },

      ]

      $rootScope.components = loComponentsService.getComponents()

      #listen for emitted objects out of directives
      $scope.$on 'selectedParticipationType', (event, type) ->
        $scope.selectedParticipationType = type

      $scope.$on 'selectedDonationLevel', (event, level) ->
        $scope.selectedDonationLevel = level

      $scope.$on 'loginResponse', (event, info) ->
        console.log info
        $scope.loggedInConstituent = info

      #example of setting object to pass into topList directive
      TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=&fr_id=' + $scope.ctrl.frId
          .then (response) ->
            $scope.topList = response.data.getParticipantsResponse.participant

      #example of setting array to pass into badge directive
      $scope.participantBadges = []
      TeamraiserParticipantService.getParticipants '&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + $scope.ctrl.frId + '&list_filter_column=reg.cons_id&list_filter_text=1001493'
          .then (response) ->
            badges = response.data.getParticipantsResponse?.participant.badges
            badges.participantMilestoneLargeBadgeUrl = badges.participantMilestoneLargeBadgeUrl.replace '/lg_', '/'
            if badges.participantMilestoneLargeBadgeUrl
              participantMilestoneBadge =
                url: 'https://secure2.convio.net/psdemo/' + badges.participantMilestoneLargeBadgeUrl
                name: badges.participantMilestoneBadgeName
                text: badges.participantMilestoneBadgeDesc
              $scope.participantBadges.push participantMilestoneBadge


      #example of setting object to pass into donationLevels directive
      $scope.donationLevels = 'loading'
      TeamraiserEventService.getTeamraiserConfig 'fr_id=' + $scope.ctrl.frId
        .then (response) ->
          if response.data.getTeamraiserConfigResponse
            $scope.donationLevels = response.data.getTeamraiserConfigResponse.teamraiserConfig.donationLevels

      #example of setting object to pass into participationTypes directive
      $scope.participationTypes = 'loading'
      TeamraiserRegistrationService.getParticipationTypes 'fr_id=' + $scope.ctrl.frId
        .then (response) ->
          if response.data.getParticipationTypesResponse
            $scope.participationTypes = response.data.getParticipationTypesResponse.participationType

      ### TO DO - CHANGE TO PROMISE
      $scope.participationTypesPromise = TeamraiserRegistrationService.getParticipationTypes 'fr_id=' + $scope.ctrl.frId
        .then (response) ->
          if response.data.getParticipationTypesResponse
            return response.data.getParticipationTypesResponse.participationType
      ###
  ]
