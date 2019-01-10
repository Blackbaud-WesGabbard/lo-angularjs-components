angular.module 'ngLuminateDocumentation'
  .factory 'TeamraiserEventService', [
    '$luminateTemplateTag'
    '$luminateRest'
    ($luminateTemplateTag, $luminateRest) ->
      getTeamRaiserData: (frId) ->
        teamraiserData =
          teamraiser:
            eventDate: '[[S42:' + frId + ':event-date]]'
            goal: '[[S42:' + frId + ':goal]]'
            dollars: '[[S42:' + frId + ':dollars]]'
            prevFrId: '[[S42:' + frId + ':prev-fr-id]]'
            prevEventDate: '[[E42:[[E42:' + frId + ':prev-fr-id]]:event-date]]'
            prevDollars: '[[E42:[[E42:' + frId + ':prev-fr-id]]:dollars]]'
            prevTeams: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-teams]]'
            prevParticipants: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-participants]]'
            ageMin: '[[S47:' + frId + ':fr_info:1:age_minimum]]'
        $luminateTemplateTag.parse JSON.stringify(teamraiserData)
          .then (response) ->
            return JSON.parse(response)

      getTeamraiserConfig: (requestData) ->
        dataString = 'method=getTeamraiserConfig'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
]