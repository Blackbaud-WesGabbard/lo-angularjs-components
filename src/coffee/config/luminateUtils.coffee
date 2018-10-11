angular.module 'ngLuminateLibrary'
  .config [
    '$luminateUtilsConfigProvider'
    ($luminateUtilsConfigProvider) ->
      $luminateUtilsConfigProvider.setPath
        nonsecure: luminateInstance.nonsecure
        secure: luminateInstance.secure
      .setKey luminateInstance.apiKey
      return
  ]