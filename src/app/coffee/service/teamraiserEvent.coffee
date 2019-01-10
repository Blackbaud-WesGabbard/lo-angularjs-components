angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserEventService', [
    '$luminateTemplateTag'
    '$luminateRest'
    ($luminateTemplateTag, $luminateRest) ->
      getTeamRaiserData: (frId) ->
        teamraiserData =
          teamraiser:
            eventDate: '[[S42:' + frId + ':event-date]]'
            formId: '[[S42:' + frId + ':form-id]]'
            goal: '[[S42:' + frId + ':goal]]'
            dollars: '[[S42:' + frId + ':dollars]]'
            prevFrId: '[[S42:' + frId + ':prev-fr-id]]'
            prevEventDate: '[[E42:[[E42:' + frId + ':prev-fr-id]]:event-date]]'
            prevDollars: '[[E42:[[E42:' + frId + ':prev-fr-id]]:dollars]]'
            prevTeams: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-teams]]'
            prevParticipants: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-participants]]'
            customBadge1:
              url: '[[S47:' + frId + ':fr_info:1:custom_badge_1_url]]'
              name: '[[S47:' + frId + ':fr_info:1:custom_badge_1_name]]'
            customBadge2:
              url: '[[S47:' + frId + ':fr_info:1:custom_badge_2_url]]'
              name: '[[S47:' + frId + ':fr_info:1:custom_badge_2_name]]'
            customBadge3:
              url: '[[S47:' + frId + ':fr_info:1:custom_badge_3_url]]'
              name: '[[S47:' + frId + ':fr_info:1:custom_badge_3_name]]'
            customBadge4:
              url: '[[S47:' + frId + ':fr_info:1:custom_badge_4_url]]'
              name: '[[S47:' + frId + ':fr_info:1:custom_badge_4_name]]'
            customBadge5:
              url: '[[S47:' + frId + ':fr_info:1:custom_badge_5_url]]'
              name: '[[S47:' + frId + ':fr_info:1:custom_badge_5_name]]'
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