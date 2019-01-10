angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserParticipantService', [
    '$rootScope'
    '$luminateRest'
    '$luminateUtilsConfig'
    '$luminateTemplateTag'
    ($rootScope, $luminateRest, $luminateUtilsConfig, $luminateTemplateTag) ->
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

      getParticipantProgress: (requestData) ->
        dataString = 'method=getParticipantProgress'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString

      getParticipantRank: (requestData, consId) ->
        dataString = 'method=getParticipants&&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=500'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
        .then (response) ->
          ranking = {}
          totalParticipants = response.data.getParticipantsResponse?.totalNumberResults
          participants = response.data.getParticipantsResponse?.participant
          if participants
            participants = [participants] if not angular.isArray participants
            ranking =
              rank: 0
              totalParticipants: totalParticipants
            angular.forEach participants, (participant, key) ->
              if participant.consId is String consId
                ranking =
                  rank: key + 1
                  totalParticipants: totalParticipants
                  participantInfo: participant
          ranking
  ]