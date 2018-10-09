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
            prevParticipantYears: '[[S48:' + $rootScope.frId + '-' + id + ':question:Please tell us how many years you have participated in ' + $rootScope.programName + '. We would like to recognize you for your commitment.]]'
            prevDollars: '[[E42:[[E42:' + $rootScope.frId + ':prev-fr-id]]:dollars]]'
            fbFundraiser: '[[?xxUser Provided No Responsexdeletedx::x[[S48:' + $rootScope.frId + '-' + id + ':question:Facebook Fundraiser ID:]]x::::[[S48:' + $rootScope.frId + '-' + id + ':question:Facebook Fundraiser ID:]]]]'
            mobileApp: '[[S48:' + $rootScope.frId + '-' + id + ':if-in-group:' + $rootScope.mobileAppGroupId + ']]'
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
        dataString = 'method=getParticipants&first_name=' + encodeURIComponent('%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=500'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
        .then (response) ->
          ranking = {}
          participants = response.data.getParticipantsResponse?.participant
          if participants
            participants = [participants] if not angular.isArray participants
            ranking =
              rank: 0
              total: 0
            angular.forEach participants, (participant, key) ->
              ranking.total++
              if participant.consId is String consId
                ranking =
                  rank: key + 1
                  total: ranking.total
                  amountRaised: $filter('currency')(participant.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace '.00', ''
                  amountRaisedFormatted: $filter('currency')(participant.amountRaised / 100, '$').replace '.00', ''
                  goal: $filter('currency')(participant.goal / 100, '$').replace('$', '').replace(/,/g, '').replace '.00', ''
                  goalFormatted: $filter('currency')(participant.goal / 100, '$').replace '.00', ''
                  name: participant.name.first + ' ' + participant.name.last
                  consId: participant.consId
                  pageUrl: $luminateUtilsConfig.path.secure + 'TR?fr_id=' + $rootScope.frId + '&pg=personal&px=' + participant.consId
                  donationUrl: participant.donationUrl
                  aTeamCaptain: participant.aTeamCaptain
                  teamName: participant.teamName
                  teamPageUrl: participant.teamPageUrl
          ranking
  ]