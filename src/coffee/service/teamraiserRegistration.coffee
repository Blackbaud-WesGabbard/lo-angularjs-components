angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserRegistrationService', [
    '$rootScope'
    '$luminateRest'
    ($rootScope, $luminateRest) ->
      getParticipationTypes: (requestData) ->
        dataString = 'method=getParticipationTypes&fr_id=' + $rootScope.frId
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString

      getRegistration: (requestData) ->
        dataString = 'method=getRegistration'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
          requiresAuth: true

      getRegistrationDocument: (requestData) ->
        dataString = 'method=getRegistrationDocument&fr_id=' + $rootScope.frId
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString

      updateRegistration: (requestData) ->
        dataString = 'method=updateRegistration'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
          requiresAuth: true

      validateDiscount: (requestData) ->
        dataString = 'method=validateDiscount&fr_id=' + $rootScope.frId
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString


  ]