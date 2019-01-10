angular.module 'ngLuminateLibrary'
  .config [
    '$luminateUtilsConfigProvider'
    ($luminateUtilsConfigProvider) ->
      $luminateUtilsConfigProvider.setPath
        nonsecure: luminateProperties.nonSecure
        secure: luminateProperties.secure
      .setKey luminateProperties.apiKey
      return
  ]