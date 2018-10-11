angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserParticipantService', [
    '$rootScope'
    '$filter'
    '$luminateRest'
    '$luminateUtilsConfig'
    '$luminateTemplateTag'
    ($rootScope, $filter, $luminateRest, $luminateUtilsConfig, $luminateTemplateTag) ->
      getParticipantData: (id) ->
        participantData =
          participant:
            selfDonor: '[[S48:' + $rootScope.frId + '-' + id + ':if-is-self-donor]]'
            teamCaptain: '[[S48:' + $rootScope.frId + '-' + id + ':if-is-captain]]'
            onTeam: '[[S48:' + $rootScope.frId + '-' + id + ':if-on-team]]'
            prevParticipant: '[[E48:[[S42:' + $rootScope.frId + ':prev-fr-id]]-' + id + ':participant-id]]'
            prevDollars: '[[E42:[[E42:' + $rootScope.frId + ':prev-fr-id]]:dollars]]'
            fbFundraiser: '[[?xxUser Provided No Responsexdeletedx::x[[S48:' + $rootScope.frId + '-' + id + ':question:Facebook Fundraiser ID:]]x::::[[S48:' + $rootScope.frId + '-' + id + ':question:Facebook Fundraiser ID:]]]]'
            sentEmail:  '[[S48:' + $rootScope.frId + '-' + id + ':if-emails-gt:0]]'
            updatedPage: '[[S48:' + $rootScope.frId + '-' + id + ':if-page-updated]]'
        $luminateTemplateTag.parse JSON.stringify(participantData)
          .then (response) ->
            return JSON.parse(response)

      getParticipants: (requestData) ->
        dataString = 'method=getParticipants'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
  ]