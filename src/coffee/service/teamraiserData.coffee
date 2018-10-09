angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserDataService', [
    '$rootScope'
    '$luminateTemplateTag'
    ($rootScope, $luminateTemplateTag) ->
      getTeamRaiserData: ->
        teamraiserData =
          teamraiser:
            eventDate: '[[S42:' + $rootScope.frId + ':event-date]]'
            goal: '[[S42:' + $rootScope.frId + ':goal]]'
            dollars: '[[S42:' + $rootScope.frId + ':dollars]]'
            prevFrId: '[[S42:' + $rootScope.frId + ':prev-fr-id]]'
            prevEventDate: '[[E42:[[E42:' + $rootScope.frId + ':prev-fr-id]]:event-date]]'
            prevDollars: '[[E42:[[E42:' + $rootScope.frId + ':prev-fr-id]]:dollars]]'
            prevTeams: '[[E42:[[E42:' + $rootScope.frId + ':prev-fr-id]]:num-teams]]'
            prevParticipants: '[[E42:[[E42:' + $rootScope.frId + ':prev-fr-id]]:num-participants]]'
            ageMin: '[[S47:' + $rootScope.frId + ':fr_info:1:age_minimum]]'

        $luminateTemplateTag.parse JSON.stringify(teamraiserData)
          .then (response) ->
            return JSON.parse(response)
]