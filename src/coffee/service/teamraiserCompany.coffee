angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserCompanyService', [
    '$luminateRest'
    ($luminateRest) ->
      getCompanies: (requestData) ->
        dataString = 'method=getCompaniesByInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
  ]