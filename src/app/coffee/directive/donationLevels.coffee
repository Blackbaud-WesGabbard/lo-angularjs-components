angular.module 'luminateControllers'
  .directive 'donationLevels', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/donationLevels.html'
      scope:
        frId: '@'
        formId: '@'
        buttonSize: '@'
        noThanks: '@'
        donationLevelsData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        'TeamraiserEventService'
        'DonationService'
        ($rootScope, $scope, TeamraiserEventService, DonationService) ->
          $scope.state =
            activeLevel: null
            donationFee: 0
            type: null
          $scope.donationLevels = 'loading'

          setLevels = (levels) ->
            $scope.donationLevels = levels
            $scope.state.type = if levels.manualAllowed then 'registration' else 'donation'

          if $scope.donationLevelsData
            setLevels $scope.donationLevelsData
            $scope.$watch 'donationLevelsData', (value) ->
              setLevels $scope.donationLevelsData
          else
            if $scope.formId
              DonationService.getDonationFormInfo 'form_id=' + $scope.formId
                .then (response) ->
                  if response.data.getDonationFormInfoResponse
                    setLevels response.data.getDonationFormInfoResponse.donationLevels
            else if $scope.frId
              TeamraiserEventService.getTeamraiserConfig 'fr_id=' + $scope.frId
                .then (response) ->
                  if response.data.getTeamraiserConfigResponse
                    setLevels response.data.getTeamraiserConfigResponse.teamraiserConfig.donationLevels

          $scope.setOtherAmount = (amount) ->
            $scope.state.ng_donation_level = '-1'
            $scope.state.ng_donation_level_other_amount = amount
            amount = amount.replace '$', ''
            if amount is '0'
              $scope.state.donationFee = 0
            else
              $scope.state.donationFee = Number(amount) * 100

          $scope.toggleDonationLevel = (level) ->
            if level is 'none'
              $scope.state.ng_donation_level_other_amount = ''
              $scope.state.ng_donation_level = '$0.00'
              $scope.state.activeLevel = level
              $scope.state.donationFee = 0
            else if level is 'other'
              $scope.state.activeLevel = level
              if $scope.state.ng_donation_level_other_amount is undefined
                $scope.setOtherAmount ''
              else
                $scope.setOtherAmount $scope.state.ng_donation_level_other_amount
            else
              $scope.state.ng_donation_level_other_amount = ''
              $scope.state.ng_donation_level = level.amount.formatted
              $scope.state.activeLevel = level.amount.formatted
              $scope.state.donationFee = Number(level.amount.decimal) * 100

          $scope.$watch 'state', ((newVal, oldVal) ->
            if newVal != oldVal
              $scope.$emit 'selectedDonationLevel', $scope.state
            return
          ), true
      ]
  ]