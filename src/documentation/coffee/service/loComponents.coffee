angular.module 'ngLuminateDocumentation'
  .factory 'loComponentsService', [
    '$luminateRest'
    ($luminateRest) ->
      getComponents: ->
        components =
          ###
          createUserForm:
            layout:
              format: 'string'
              description: 'Horizontal or Vertical'
          ###
          donationLevels:
            frId:
              format: 'string'
              description: 'TeamRaiser id is required if pulling in additional donation levels for registration.'
            formId:
              format: 'string'
              description: 'Donation form id is required if pulling in levels from a donation form.'
            buttonSize:
              format: 'string'
              description: 'Can set the size size of buttons to "sm" or "lg"'
            noThanks:
              format: 'boolean'
              description: 'Set to true to display a No Thanks button that will reset out selections'
            donationLevelsData:
              format: 'object'
              description: 'Pass donationLevels as an object if data already present. This is preffered method when data aleady in scope to prevent redundant API calls.'
            selectedDonationLevel:
              format: 'object'
              description: 'Object properties associated with a selected donation level emitted out of the directive. These properties can be used in a parent controller to set donation level and amount. Retrieve in parent controller with:
                <br />
                <code>$scope.$on "selectedDonationLevel", (event, type) -></code>'

          donorTeamSearch:
            frId:
              format: 'string'
              description: 'Will execute search based on the TeamRaiser ID if set, otherwise must set eventType'
            eventType:
              format: 'string'
              description: 'Will execute search based on TeamRaiser Primary Event type if set, otherwise must set frId. This should be used when trying to execute search from several TeamRaisers with the same Primary Event Type.'
            sizeLimit:
              format: 'string'
              description: 'Set size limit of search results. Default set to 25.'
            sortAscending:
              format: 'boolean'
              description: 'Sort results in ascending order by name. Default set to true.'
            showBadges:
              format: 'boolean'
              description: 'By default set to false. If set to true then will show default Luminate badges. This includes Milestone and Personal Gift Badges (does not inlcude custom badges).'

          honorRoll:
            frId:
              format: 'string'
              description: 'TeamRaiser id is optional if embedded in TeamRaiser or using listData to pass data, otherwise required.'
            type:
              format: 'string'
              description: 'If not passing listData object then required, can be set to either participant or team'
            id:
              format: 'string'
              description: 'If not passing listData object, then must pass id attribute. Pass Constituent ID for participant or Team ID for team.'
            sizeLimit:
              format: 'string'
              description: 'Optional. Set the size of the list. By default set at 100.'
            listData:
              format: 'array'
              description: 'Pass the listData as an array if data already in scope.'

          loginForm:
            layout:
              format: 'string'
              description: 'Set layout to horizontal or vertical. Defaults to vertical.'
            showLables:
              format: 'string'
              description: 'Set whether form lables are visible. Defaults to true.'
            formSize:
              format: 'string'
              description: 'Override size of form elements and submit button. Can be set to sm or lg.'

          loadingIndicator:
            size:
              format: 'string'
              description: 'Set the size of the loading indicator based on rem. Accepts values 1-9, defaults to 4 if not set.'
            text:
              format: 'string'
              description: 'Set to add text underneath indicator.'

          participationTypes:
            participationTypesData:
              format: 'object'
              description: 'Pass object through the participationTypesData attribute if data already present. This is preffered method when data aleady in scope to prevent redundant API calls. Otherwise set frId attribute.'
            frId:
              format: 'string'
              description: 'Can pass TeamRaiser Id if not using participationTypesData attribute.'
            layout:
              format: 'string'
              description: 'Default is horizontal. Set as vertical to stack particpation types into selectable panels.'
            selectedParticipationType:
              format: 'object'
              description: 'Object properties associated with a selected participation type emitted out of the directive. These properties can be used in parent controller to set Participation Type. Can be retrieved in parent controller with:
                <br />
                <code>$scope.$on "selectedParticipationType", (event, type) -></code>'

          passwordReset:
            email:
              format: 'string'
              description: 'Required, specify the email to send the password reset to either with object property if email addrtess is in scope, string, or with S tag [[S1:primary_email]]'
            type:
              format: 'string'
              description: 'Defaults to link with no button styles, but can set to lg or sm to apply button styles.'
            size:
              format: 'string'
              description: 'Size of button, defaults to md. Can be set to either lg or sm. '

          progressBadges:
            frId:
              format: 'string'
              description: 'TeamRaiser id is required unless passing object using either customBadgeData attributes.'
            type:
              format: 'string'
              description: 'Required unless passing object using customBadgeData attributes. Set as individual or team.'
            id:
              format: 'string'
              description: 'Pass id attribute for individual or team. Required unless passing object using customBadgeData attributes.'
            customBadgeData:
              format: 'array'
              description: 'Can pass data as an array to set Custom Badges. Must set properties of url and name for each object in array. Optional property of text can bu used to set description of badge.'

          progressMeter:
            frId:
              format: 'string'
              description: 'TeamRaiser id is required unless passing object data using the progressData attribute.'
            type:
              format: 'string'
              description: 'Required if not passing progressData attribute. Set as event, individual, team, or company.'
            id:
              format: 'string'
              description: 'If not setting progressData attribute, then must pass id attribute for individual, team or company meters. Not needed for Event Meters.'
            showMeterPercent:
              format: 'string'
              description: 'Can set the minimum percent of the meter before it will show'
            progressData:
              format: 'object'
              description: 'Pass object in progressData attribute if data already present in scope. Must pass amount and goal properties in cents (ie 10 dollars would be 1000). This is preffered method when data aleady in scope to prevent redundant API calls.'

          rosterList:
            frId:
              format: 'string'
              description: 'TeamRaiser id is optional if embedded in TeamRaiser, otherwise required.'
            type:
              format: 'string'
              description: 'Required. Set to teamParticipants, companyParticipants or companyTeams'
            id:
              format: 'string'
              description: 'Required. Set either team or company id.'
            buttonSize:
              format: 'string'
              description: 'Optional. Can set the size size of buttons to "sm" or "lg"'
            includeSearch:
              format: 'boolean'
              description: 'Optional. By default set to false. Set to true to include search fields to filter the list'
            showBadges:
              format: 'boolean'
              description: 'Optional. By default set to false. If set to true then will show default Luminate badges. This includes Milestone and Personal Gift Badges (does not inlcude custom badges).'
            sizeLimit:
              format: 'string'
              description: 'Optional. Set the size of the list. By default set at 25, has a max of 500.'
            sortAscending:
              format: 'string'
              description: 'Optional. By default set to false.'
            sortColumn:
              format: 'string'
              description: 'Optional. Defaults to "total" (amount raised), can be overridden by setting to "first_name" for participants or "name" for teams.'
            tableStripe:
              format: 'boolean'
              description: 'Optional. Set to true for striped table results.'

          topList:
            frId:
              format: 'string or object'
              description: 'TeamRaiser id is required unless passing data as an array using the listData attribute.'
            type:
              format: 'string'
              description: 'Optional if using listData atribute. Otherwise must be set to either participant, team, or company.'
            ###
            id:
              format: 'string or object'
              description: 'Optional. By default will fetch based on TeamRaiser Event. However can pass Team id or Company id to change list.'
            ###
            sizeLimit:
              format: 'string'
              description: 'Optional. Set the size of the list. By default set at 25, has a max of 500.'
            showBadges:
              format: 'boolean'
              description: 'By default set to false. If set to true then will show default Luminate badges. This includes Milestone and Personal Gift Badges (currently does not inlcude custom badges).'
            listData:
              format: 'array'
              description: 'Pass an array through the listData attribute if data already present. This is preffered method when data aleady in scope to prevent redundant API calls.'

        return components

  ]
