(function() {
  var appDependencies;

  appDependencies = ['ngSanitize', 'ngTouch', 'ngAria', 'ui.bootstrap', 'ngLuminateUtils', 'trControllers'];

  angular.forEach(['textAngular'], function(appDependency) {
    var error, error1;
    try {
      angular.module(appDependency);
      return appDependencies.push(appDependency);
    } catch (error1) {
      error = error1;
    }
  });

  angular.module('loComponents', appDependencies);

  angular.module('loControllers', []);

  angular.module('loComponents').constant('APP_INFO', {
    version: '1.0.0',
    rootPath: (function() {
      var rootPath;
      rootPath = '/';
      return rootPath;
    })()
  });

  angular.module('loComponents').run([
    '$rootScope', function($rootScope) {
      var $dataRoot;
      $dataRoot = angular.element('[data-root]');
      $rootScope.frId = $dataRoot.data('fr-id') && !isNaN($dataRoot.data('fr-id')) ? Number($dataRoot.data('fr-id')) : null;
      if ($dataRoot.data('secure-domain') !== '') {
        $rootScope.secureDomain = $dataRoot.data('secure-domain');
      }
      if ($dataRoot.data('api-key') !== '') {
        $rootScope.apiKey = $dataRoot.data('api-key');
      }
      if ($dataRoot.data('auth-token') !== '') {
        $rootScope.authToken = $dataRoot.data('auth-token');
      }
      if ($dataRoot.data('cons-id') !== '') {
        $rootScope.consId = $dataRoot.data('cons-id');
      }
      if ($dataRoot.data('first-name') !== '') {
        $rootScope.firstName = $dataRoot.data('first-name');
      }
      if ($dataRoot.data('last-name') !== '') {
        $rootScope.lastName = $dataRoot.data('last-name');
      }
      if ($dataRoot.data('team-id') !== '') {
        $rootScope.partTeamId = $dataRoot.data('team-id');
      }
      if ($dataRoot.data('part-type-id') !== '') {
        $rootScope.partTypeId = $dataRoot.data('part-type-id');
      }
      if ($dataRoot.data('session-cookie') !== '') {
        $rootScope.sessionCookie = $dataRoot.data('session-cookie');
      }
      if ($dataRoot.data('table-prefix') !== '') {
        return $rootScope.tablePrefix = $dataRoot.data('table-prefix');
      }
    }
  ]);

  angular.element(document).ready(function() {
    var appModules;
    appModules = ['loComponents'];
    return angular.bootstrap(document, appModules);
  });

}).call(this);
