angular.module 'ngLuminateLibrary'
  .config [
    '$luminateUtilsConfigProvider'
    ($luminateUtilsConfigProvider) ->
      $luminateUtilsConfigProvider.setPath
        nonsecure: 'http://psdemo.convio.net/site/'
        secure: 'https://secure2.convio.net/psdemo/site/'
      .setKey 'wDB09SQODRpVIOvX'
      return
  ]