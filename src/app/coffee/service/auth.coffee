angular.module 'ngLuminateLibrary'
  .factory 'AuthService', [
    '$luminateRest'
    ($luminateRest) ->
      login: (requestData) ->
        dataString = 'method=login'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'cons'
          data: dataString

      createUser: (requestData) ->
        dataString = 'method=create'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'cons'
          data: dataString

      updateUser: (requestData) ->
        dataString = 'method=update'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'cons'
          data: dataString
          requiresAuth: true

      changePassword: (requestData, callback) ->
        dataString = 'method=changePassword'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'cons'
          data: dataString
          requiresAuth: true
  ]
