angular.module 'ngLuminateLibrary'
  .factory 'DonationService', [
    '$luminateRest'
    ($luminateRest) ->
      getDonationFormInfo: (requestData) ->
        dataString = 'method=getDonationFormInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'donation'
          data: dataString
  ]