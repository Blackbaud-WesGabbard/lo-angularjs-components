(function() {
  var appDependencies;

  appDependencies = ['ui.bootstrap', 'ngLuminateUtils', 'luminateControllers'];

  angular.module('ngLuminateLibrary', appDependencies);

  angular.module('luminateControllers', []);

  angular.module('ngLuminateLibrary').constant('APP_INFO', {
    version: '1.0.0',
    rootPath: (function() {
      var rootPath;
      rootPath = '/';
      return rootPath;
    })()
  });

  angular.module('ngLuminateLibrary').run([
    '$rootScope', function($rootScope) {
      var $dataRoot;
      $dataRoot = jQuery('[data-luminate-root]');
      return $rootScope.frId = $dataRoot.data('fr-id') && !isNaN($dataRoot.data('fr-id')) ? Number($dataRoot.data('fr-id')) : null;
    }
  ]);

  angular.element(document).ready(function() {
    var appModules;
    appModules = ['ngLuminateLibrary'];
    return angular.bootstrap(document, appModules);
  });

  angular.module('ngLuminateLibrary').config([
    '$luminateUtilsConfigProvider', function($luminateUtilsConfigProvider) {
      $luminateUtilsConfigProvider.setPath({
        nonsecure: luminateInstance.nonsecure,
        secure: luminateInstance.secure
      }).setKey(luminateInstance.apiKey);
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserCompanyService', [
    '$luminateRest', function($luminateRest) {
      return {
        getCompanies: function(requestData) {
          var dataString;
          dataString = 'method=getCompaniesByInfo';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          });
        }
      };
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserEventService', [
    '$luminateTemplateTag', function($luminateTemplateTag) {
      return {
        getTeamRaiserData: function(frId) {
          var teamraiserData;
          teamraiserData = {
            teamraiser: {
              eventDate: '[[S42:' + frId + ':event-date]]',
              goal: '[[S42:' + frId + ':goal]]',
              dollars: '[[S42:' + frId + ':dollars]]',
              prevFrId: '[[S42:' + frId + ':prev-fr-id]]',
              prevEventDate: '[[E42:[[E42:' + frId + ':prev-fr-id]]:event-date]]',
              prevDollars: '[[E42:[[E42:' + frId + ':prev-fr-id]]:dollars]]',
              prevTeams: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-teams]]',
              prevParticipants: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-participants]]',
              ageMin: '[[S47:' + frId + ':fr_info:1:age_minimum]]'
            }
          };
          return $luminateTemplateTag.parse(JSON.stringify(teamraiserData)).then(function(response) {
            return JSON.parse(response);
          });
        }
      };
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserParticipantService', [
    '$rootScope', '$filter', '$luminateRest', '$luminateUtilsConfig', '$luminateTemplateTag', function($rootScope, $filter, $luminateRest, $luminateUtilsConfig, $luminateTemplateTag) {
      return {
        getParticipantData: function(id) {
          var participantData;
          participantData = {
            participant: {
              selfDonor: '[[S48:' + $rootScope.frId + '-' + id + ':if-is-self-donor]]',
              teamCaptain: '[[S48:' + $rootScope.frId + '-' + id + ':if-is-captain]]',
              onTeam: '[[S48:' + $rootScope.frId + '-' + id + ':if-on-team]]',
              prevParticipant: '[[E48:[[S42:' + $rootScope.frId + ':prev-fr-id]]-' + id + ':participant-id]]',
              prevDollars: '[[E42:[[E42:' + $rootScope.frId + ':prev-fr-id]]:dollars]]',
              fbFundraiser: '[[?xxUser Provided No Responsexdeletedx::x[[S48:' + $rootScope.frId + '-' + id + ':question:Facebook Fundraiser ID:]]x::::[[S48:' + $rootScope.frId + '-' + id + ':question:Facebook Fundraiser ID:]]]]',
              sentEmail: '[[S48:' + $rootScope.frId + '-' + id + ':if-emails-gt:0]]',
              updatedPage: '[[S48:' + $rootScope.frId + '-' + id + ':if-page-updated]]'
            }
          };
          return $luminateTemplateTag.parse(JSON.stringify(participantData)).then(function(response) {
            return JSON.parse(response);
          });
        },
        getParticipants: function(requestData) {
          var dataString;
          dataString = 'method=getParticipants';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          });
        }
      };
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserRegistrationService', [
    '$luminateRest', function($luminateRest) {
      return {
        getParticipationTypes: function(requestData) {
          var dataString;
          dataString = 'method=getParticipationTypes';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          });
        }
      };
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserTeamService', [
    '$luminateRest', function($luminateRest) {
      return {
        getTeams: function(requestData) {
          var dataString;
          dataString = 'method=getTeamsByInfo';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString,
            requiresAuth: true
          });
        }
      };
    }
  ]);

  angular.module('luminateControllers').controller('MainCtrl', [
    '$scope', function($scope) {
      return $scope.ctrl = {
        hide: false,
        frId: 1070,
        consId: 1001491,
        teamId: 1057,
        companyId: 1013,
        amount: 56500,
        goal: 140000
      };
    }
  ]);

  angular.module('luminateControllers').directive('participationTypes', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'dist/html/directive/participationTypes.html',
        scope: {
          frId: '=?',
          layout: '@'
        },
        controller: [
          '$rootScope', '$scope', 'TeamraiserRegistrationService', function($rootScope, $scope, TeamraiserRegistrationService) {
            var eventId;
            eventId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.participationOptions = {
              participationTypeId: null
            };
            $scope.participationTypes = [];
            return TeamraiserRegistrationService.getParticipationTypes('fr_id=' + eventId).then(function(response) {
              if (response.data.getParticipationTypesResponse) {
                return $scope.participationTypes = response.data.getParticipationTypesResponse.participationType;
              }
            });
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('progressMeter', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'dist/html/directive/progressMeter.html',
        scope: {
          type: '@',
          showMeterPercent: '@',
          id: '=?',
          frId: '=?',
          progressData: '=?'
        },
        controller: [
          '$rootScope', '$scope', '$filter', 'TeamraiserEventService', 'TeamraiserParticipantService', 'TeamraiserTeamService', 'TeamraiserCompanyService', function($rootScope, $scope, $filter, TeamraiserEventService, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) {
            var eventId, hideMeter, percent, setMeter;
            eventId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.meter = {
              goal: 0,
              dollars: 0,
              percent: 0,
              hideMeter: null
            };
            setMeter = function(amount, goal) {
              var percent;
              percent = (amount / goal) * 100;
              return $scope.meter = {
                dollars: $filter('currency')(amount / 100, '$').replace('.00', ''),
                goal: $filter('currency')(goal / 100, '$').replace('.00', ''),
                percent: String(Math.round(percent)) + '%',
                hideMeter: percent < $scope.showMeterPercent || percent === Infinity || percent === NaN ? true : null
              };
            };
            if ($scope.progressData) {
              percent = $scope.progressData.amount / $scope.progressData.goal;
              hideMeter = percent < $scope.showMeterPercent ? true : null;
              return setMeter($scope.progressData.amount, $scope.progressData.goal, hideMeter);
            } else {
              if ($scope.type === 'event') {
                TeamraiserEventService.getTeamRaiserData(eventId).then(function(response) {
                  var dollars, goal, teamraiser;
                  if (response.teamraiser) {
                    teamraiser = response.teamraiser;
                    dollars = Number(teamraiser.dollars.replace(/[^\d.]/g, ''));
                    goal = Number(teamraiser.goal.replace(/[^\d.]/g, ''));
                    return setMeter(dollars * 100, goal * 100);
                  }
                });
              }
              if ($scope.type === 'individual') {
                TeamraiserParticipantService.getParticipants('&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + eventId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id).then(function(response) {
                  var participant;
                  if (response.data.getParticipantsResponse) {
                    participant = response.data.getParticipantsResponse.participant;
                    return setMeter(Number(participant.amountRaised), Number(participant.goal));
                  }
                });
              }
              if ($scope.type === 'team') {
                TeamraiserTeamService.getTeams('team_id=' + $scope.id + '&fr_id=' + eventId).then(function(response) {
                  var team;
                  if (response.data.getTeamSearchByInfoResponse) {
                    team = response.data.getTeamSearchByInfoResponse.team;
                    return setMeter(Number(team.amountRaised), Number(team.goal));
                  }
                });
              }
              if ($scope.type === 'company') {
                return TeamraiserCompanyService.getCompanies('company_id=' + $scope.id + '&fr_id=' + eventId).then(function(response) {
                  var company;
                  if (response.data.getCompaniesResponse) {
                    company = response.data.getCompaniesResponse.company;
                    return setMeter(company.amountRaised, company.goal);
                  }
                });
              }
            }
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('topList', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'dist/html/directive/topList.html',
        scope: {
          type: '@',
          sizeLimit: '@',
          showBadges: '@',
          id: '=?',
          frId: '=?',
          listData: '=?'
        },
        controller: [
          '$rootScope', '$scope', '$filter', 'TeamraiserEventService', 'TeamraiserParticipantService', 'TeamraiserTeamService', 'TeamraiserCompanyService', function($rootScope, $scope, $filter, TeamraiserEventService, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) {
            var sizeLimit;
            $scope.eventId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.list = {};
            sizeLimit = $scope.sizeLimit ? $scope.sizeLimit : 500;
            if ($scope.listData) {
              return console.log(listData);
            } else {
              if ($scope.type === 'participants') {
                TeamraiserParticipantService.getParticipants('&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.eventId).then(function(response) {
                  if (response.data.getParticipantsResponse) {
                    return $scope.list = response.data.getParticipantsResponse.participant;
                  }
                });
              }
              if ($scope.type === 'teams') {
                TeamraiserTeamService.getTeams('team_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.eventId).then(function(response) {
                  if (response.data.getTeamSearchByInfoResponse) {
                    return $scope.list = response.data.getTeamSearchByInfoResponse.team;
                  }
                });
              }
              if ($scope.type === 'companies') {
                return TeamraiserCompanyService.getCompanies('company_name=' + encodeURIComponent('%%%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.eventId).then(function(response) {
                  if (response.data.getCompaniesResponse) {
                    return $scope.list = response.data.getCompaniesResponse.company;
                  }
                });
              }
            }
          }
        ]
      };
    }
  ]);

}).call(this);
