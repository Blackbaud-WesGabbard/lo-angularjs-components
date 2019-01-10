angular.module 'ngLuminateDocumentation'
  .factory 'TeamraiserTeamService', [
    '$luminateRest'
    ($luminateRest) ->
      getTeams: (requestData) ->
        dataString = 'method=getTeamsByInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
          requiresAuth: true
  ]