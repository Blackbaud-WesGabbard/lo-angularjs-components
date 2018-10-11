angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserRegistrationService', [
    '$luminateRest'
    ($luminateRest) ->
      getParticipationTypes: (requestData) ->
        dataString = 'method=getParticipationTypes'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
  ]