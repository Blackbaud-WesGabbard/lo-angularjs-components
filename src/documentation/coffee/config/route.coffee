angular.module 'ngLuminateDocumentation'
  .config [
    '$routeProvider'
    'DOC_INFO'
    ($routeProvider, DOC_INFO) ->
      $routeProvider
      .when '/',
        templateUrl: DOC_INFO.rootPath + 'html/view/intro.html'
      .when '/donationLevels',
        templateUrl: DOC_INFO.rootPath + 'html/view/donation-levels.html'
      .when '/donorTeamSearch',
        templateUrl: DOC_INFO.rootPath + 'html/view/donor-team-search.html'
      .when '/honorRoll',
        templateUrl: DOC_INFO.rootPath + 'html/view/honor-roll.html'
      .when '/loginForm',
        templateUrl: DOC_INFO.rootPath + 'html/view/login-form.html'
      .when '/loadingIndicator',
        templateUrl: DOC_INFO.rootPath + 'html/view/loading-indicator.html'
      .when '/participationTypes',
        templateUrl: DOC_INFO.rootPath + 'html/view/participation-types.html'
      .when '/passwordReset',
        templateUrl: DOC_INFO.rootPath + 'html/view/password-reset.html'
      .when '/progressBadges',
        templateUrl: DOC_INFO.rootPath + 'html/view/progress-badges.html'
      .when '/progressMeter',
        templateUrl: DOC_INFO.rootPath + 'html/view/progress-meters.html'
      .when '/rosterList',
        templateUrl: DOC_INFO.rootPath + 'html/view/roster-list.html'
      .when '/topList',
        templateUrl: DOC_INFO.rootPath + 'html/view/top-list.html'

  ]
