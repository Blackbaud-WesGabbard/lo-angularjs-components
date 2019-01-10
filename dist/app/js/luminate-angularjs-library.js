(function() {
  var appDependencies;

  appDependencies = ['ngSanitize', 'ngTouch', 'ui.bootstrap', 'ngLuminateUtils', 'luminateControllers'];

  angular.module('ngLuminateLibrary', appDependencies);

  angular.module('luminateControllers', []);

  angular.module('ngLuminateLibrary').constant('APP_INFO', {
    version: '1.0.0',
    rootPath: (function() {
      var libRoot, rootPath;
      rootPath = '../dist/app/';
      libRoot = luminateProperties.ngLibraryRoot;
      if (libRoot && libRoot !== '') {
        rootPath = libRoot;
      }
      return rootPath;
    })()
  });

  angular.module('ngLuminateLibrary').run([
    '$rootScope', function($rootScope) {
      $rootScope.frId = luminateProperties.frId ? luminateProperties.frId : null;
      $rootScope.nonSecure = luminateProperties.nonSecure;
      $rootScope.secure = luminateProperties.secure;
      return $rootScope.path = luminateProperties.secure.replace('/site/', '');
    }
  ]);

  angular.element(document).ready(function() {
    if (!angular.element(document).injector()) {
      return angular.bootstrap(document, ['ngLuminateLibrary']);
    }
  });

  angular.module('ngLuminateLibrary').config([
    '$luminateUtilsConfigProvider', function($luminateUtilsConfigProvider) {
      $luminateUtilsConfigProvider.setPath({
        nonsecure: luminateProperties.nonSecure,
        secure: luminateProperties.secure
      }).setKey(luminateProperties.apiKey);
    }
  ]);

  angular.module('ngLuminateLibrary').factory('AuthService', [
    '$luminateRest', function($luminateRest) {
      return {
        login: function(requestData) {
          var dataString;
          dataString = 'method=login';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'cons',
            data: dataString
          });
        },
        createUser: function(requestData) {
          var dataString;
          dataString = 'method=create';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'cons',
            data: dataString
          });
        },
        updateUser: function(requestData) {
          var dataString;
          dataString = 'method=update';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'cons',
            data: dataString,
            requiresAuth: true
          });
        },
        changePassword: function(requestData, callback) {
          var dataString;
          dataString = 'method=changePassword';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'cons',
            data: dataString,
            requiresAuth: true
          });
        }
      };
    }
  ]);

  angular.module('ngLuminateLibrary').factory('DonationService', [
    '$luminateRest', function($luminateRest) {
      return {
        getDonationFormInfo: function(requestData) {
          var dataString;
          dataString = 'method=getDonationFormInfo';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'donation',
            data: dataString
          });
        }
      };
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserCompanyService', [
    '$rootScope', '$luminateRest', '$luminateTemplateTag', function($rootScope, $luminateRest, $luminateTemplateTag) {
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
        },
        getCoordinatorData: function(id) {
          var coordinatorData;
          coordinatorData = {
            coordinator: {
              firstName: '[[E48:' + $rootScope.frId + '-' + id + ':cons.first_name]]',
              lastName: '[[E48:' + $rootScope.frId + '-' + id + ':cons.last_name]]',
              email: '[[E48:' + $rootScope.frId + '-' + id + ':cons.primary_email]]',
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
          return $luminateTemplateTag.parse(JSON.stringify(coordinatorData)).then(function(response) {
            return JSON.parse(response);
          });
        }
      };
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserEventService', [
    '$luminateTemplateTag', '$luminateRest', function($luminateTemplateTag, $luminateRest) {
      return {
        getTeamRaiserData: function(frId) {
          var teamraiserData;
          teamraiserData = {
            teamraiser: {
              eventDate: '[[S42:' + frId + ':event-date]]',
              formId: '[[S42:' + frId + ':form-id]]',
              goal: '[[S42:' + frId + ':goal]]',
              dollars: '[[S42:' + frId + ':dollars]]',
              prevFrId: '[[S42:' + frId + ':prev-fr-id]]',
              prevEventDate: '[[E42:[[E42:' + frId + ':prev-fr-id]]:event-date]]',
              prevDollars: '[[E42:[[E42:' + frId + ':prev-fr-id]]:dollars]]',
              prevTeams: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-teams]]',
              prevParticipants: '[[E42:[[E42:' + frId + ':prev-fr-id]]:num-participants]]',
              customBadge1: {
                url: '[[S47:' + frId + ':fr_info:1:custom_badge_1_url]]',
                name: '[[S47:' + frId + ':fr_info:1:custom_badge_1_name]]'
              },
              customBadge2: {
                url: '[[S47:' + frId + ':fr_info:1:custom_badge_2_url]]',
                name: '[[S47:' + frId + ':fr_info:1:custom_badge_2_name]]'
              },
              customBadge3: {
                url: '[[S47:' + frId + ':fr_info:1:custom_badge_3_url]]',
                name: '[[S47:' + frId + ':fr_info:1:custom_badge_3_name]]'
              },
              customBadge4: {
                url: '[[S47:' + frId + ':fr_info:1:custom_badge_4_url]]',
                name: '[[S47:' + frId + ':fr_info:1:custom_badge_4_name]]'
              },
              customBadge5: {
                url: '[[S47:' + frId + ':fr_info:1:custom_badge_5_url]]',
                name: '[[S47:' + frId + ':fr_info:1:custom_badge_5_name]]'
              }
            }
          };
          return $luminateTemplateTag.parse(JSON.stringify(teamraiserData)).then(function(response) {
            return JSON.parse(response);
          });
        },
        getTeamraiserConfig: function(requestData) {
          var dataString;
          dataString = 'method=getTeamraiserConfig';
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

  angular.module('ngLuminateLibrary').factory('TeamraiserParticipantService', [
    '$rootScope', '$luminateRest', '$luminateUtilsConfig', '$luminateTemplateTag', function($rootScope, $luminateRest, $luminateUtilsConfig, $luminateTemplateTag) {
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
        },
        getParticipantProgress: function(requestData) {
          var dataString;
          dataString = 'method=getParticipantProgress';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          });
        },
        getParticipantRank: function(requestData, consId) {
          var dataString;
          dataString = 'method=getParticipants&&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=500';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          }).then(function(response) {
            var participants, ranking, ref, ref1, totalParticipants;
            ranking = {};
            totalParticipants = (ref = response.data.getParticipantsResponse) != null ? ref.totalNumberResults : void 0;
            participants = (ref1 = response.data.getParticipantsResponse) != null ? ref1.participant : void 0;
            if (participants) {
              if (!angular.isArray(participants)) {
                participants = [participants];
              }
              ranking = {
                rank: 0,
                totalParticipants: totalParticipants
              };
              angular.forEach(participants, function(participant, key) {
                if (participant.consId === String(consId)) {
                  return ranking = {
                    rank: key + 1,
                    totalParticipants: totalParticipants,
                    participantInfo: participant
                  };
                }
              });
            }
            return ranking;
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
        },
        getRegistration: function(requestData) {
          var dataString;
          dataString = 'method=getRegistration';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString,
            requiresAuth: true
          });
        },
        getRegistrationDocument: function(requestData) {
          var dataString;
          dataString = 'method=getRegistrationDocument&fr_id=' + $rootScope.frId;
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          });
        },
        updateRegistration: function(requestData) {
          var dataString;
          dataString = 'method=updateRegistration';
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
        },
        getTeamDivisions: function(requestData) {
          var dataString;
          dataString = 'method=getTeamDivisions';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          });
        },
        getTeamRank: function(requestData, teamId) {
          var dataString;
          dataString = 'method=getTeamsByInfo&first_name=%25&last_name=%25&list_sort_column=total&list_ascending=false&list_page_size=500';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            requiresAuth: true,
            data: dataString
          }).then(function(response) {
            var ranking, ref, ref1, teams, totalTeams;
            ranking = {};
            totalTeams = (ref = response.data.getTeamSearchByInfoResponse) != null ? ref.totalNumberResults : void 0;
            teams = (ref1 = response.data.getTeamSearchByInfoResponse) != null ? ref1.team : void 0;
            if (teams) {
              if (!angular.isArray(teams)) {
                teams = [teams];
              }
              ranking = {
                rank: 0,
                total: Number(totalTeams)
              };
              angular.forEach(teams, function(team, key) {
                if (team.id === String(teamId)) {
                  return ranking = {
                    rank: key + 1,
                    totalTeams: Number(totalTeams),
                    teamInfo: team
                  };
                }
              });
            }
            return ranking;
          });
        }
      };
    }
  ]);

  angular.module('luminateControllers').directive('donationLevels', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/donationLevels.html',
        scope: {
          frId: '@',
          formId: '@',
          buttonSize: '@',
          noThanks: '@',
          donationLevelsData: '=?'
        },
        controller: [
          '$rootScope', '$scope', 'TeamraiserEventService', 'DonationService', function($rootScope, $scope, TeamraiserEventService, DonationService) {
            var setLevels;
            $scope.state = {
              activeLevel: null,
              donationFee: 0,
              type: null
            };
            $scope.donationLevels = 'loading';
            setLevels = function(levels) {
              $scope.donationLevels = levels;
              return $scope.state.type = levels.manualAllowed ? 'registration' : 'donation';
            };
            if ($scope.donationLevelsData) {
              setLevels($scope.donationLevelsData);
              $scope.$watch('donationLevelsData', function(value) {
                return setLevels($scope.donationLevelsData);
              });
            } else {
              if ($scope.formId) {
                DonationService.getDonationFormInfo('form_id=' + $scope.formId).then(function(response) {
                  if (response.data.getDonationFormInfoResponse) {
                    return setLevels(response.data.getDonationFormInfoResponse.donationLevels);
                  }
                });
              } else if ($scope.frId) {
                TeamraiserEventService.getTeamraiserConfig('fr_id=' + $scope.frId).then(function(response) {
                  if (response.data.getTeamraiserConfigResponse) {
                    return setLevels(response.data.getTeamraiserConfigResponse.teamraiserConfig.donationLevels);
                  }
                });
              }
            }
            $scope.setOtherAmount = function(amount) {
              $scope.state.ng_donation_level = '-1';
              $scope.state.ng_donation_level_other_amount = amount;
              amount = amount.replace('$', '');
              if (amount === '0') {
                return $scope.state.donationFee = 0;
              } else {
                return $scope.state.donationFee = Number(amount) * 100;
              }
            };
            $scope.toggleDonationLevel = function(level) {
              if (level === 'none') {
                $scope.state.ng_donation_level_other_amount = '';
                $scope.state.ng_donation_level = '$0.00';
                $scope.state.activeLevel = level;
                return $scope.state.donationFee = 0;
              } else if (level === 'other') {
                $scope.state.activeLevel = level;
                if ($scope.state.ng_donation_level_other_amount === void 0) {
                  return $scope.setOtherAmount('');
                } else {
                  return $scope.setOtherAmount($scope.state.ng_donation_level_other_amount);
                }
              } else {
                $scope.state.ng_donation_level_other_amount = '';
                $scope.state.ng_donation_level = level.amount.formatted;
                $scope.state.activeLevel = level.amount.formatted;
                return $scope.state.donationFee = Number(level.amount.decimal) * 100;
              }
            };
            return $scope.$watch('state', (function(newVal, oldVal) {
              if (newVal !== oldVal) {
                $scope.$emit('selectedDonationLevel', $scope.state);
              }
            }), true);
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('donorTeamSearch', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/donorTeamSearch.html',
        scope: {
          frId: '@',
          eventType: '@',
          sizeLimit: '@',
          sortAscending: '@',
          showBadges: '@'
        },
        controller: [
          '$rootScope', '$scope', '$httpParamSerializer', 'TeamraiserParticipantService', 'TeamraiserTeamService', function($rootScope, $scope, $httpParamSerializer, TeamraiserParticipantService, TeamraiserTeamService) {
            var getSearchParams;
            $scope.frId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.state = {
              isLoading: false,
              searchSubmitted: false,
              searchType: null,
              firstName: null,
              lastName: null,
              teamName: null,
              errorMessage: null,
              noResultsMsg: 'Your search returned no results.',
              searchResults: [],
              totalResults: 0,
              currentPage: 1,
              offset: null
            };
            getSearchParams = function() {
              var params;
              params = {
                list_page_size: $scope.sizeLimit ? $scope.sizeLimit : null,
                list_ascending: $scope.sortAscending ? $scope.sortAscending : null,
                list_page_offset: $scope.state.offset ? $scope.state.offset : null,
                list_sort_column: $scope.state.searchType === 'participants' ? 'first_name' : 'name'
              };
              if ($scope.eventType) {
                params.event_type = $scope.eventType;
              } else if ($scope.frId) {
                params.fr_id = $scope.frId;
              }
              if ($scope.state.searchType === 'participants') {
                params.first_name = $scope.state.firstName ? $scope.state.firstName : '%';
                params.last_name = $scope.state.lastName ? $scope.state.lastName : '%%';
                params.list_filter_column = 'private_page';
                params.list_filter_text = 0;
              }
              if ($scope.state.searchType === 'teams') {
                params.team_name = $scope.state.teamName ? $scope.state.teamName : '%%';
              }
              return params;
            };
            $scope.findParticipants = function(paginate) {
              $scope.state.isLoading = true;
              $scope.state.searchSubmitted = true;
              $scope.state.searchType = 'participants';
              if (!paginate) {
                $scope.state.currentPage = 1;
                delete $scope.state.offset;
              }
              $scope.searchTerm = $scope.state.firstName ? $scope.state.firstName : '%';
              return TeamraiserParticipantService.getParticipants($httpParamSerializer(getSearchParams())).then(function(response) {
                var ref;
                if (response.data.errorResponse) {
                  $scope.state.searchResults = [];
                  $scope.state.errorMessage = response.data.errorResponse.message;
                } else {
                  $scope.state.searchResults = (ref = response.data.getParticipantsResponse) != null ? ref.participant : void 0;
                  $scope.state.totalResults = response.data.getParticipantsResponse.totalNumberResults ? Number(response.data.getParticipantsResponse.totalNumberResults) : 0;
                  if ($scope.state.searchResults) {
                    if (!angular.isArray($scope.state.searchResults)) {
                      $scope.state.searchResults = [$scope.state.searchResults];
                    }
                  }
                  $scope.state.errorMessage = !$scope.state.searchResults ? $scope.state.noResultsMsg : null;
                }
                return delete $scope.state.isLoading;
              });
            };
            $scope.findTeams = function(paginate) {
              $scope.state.isLoading = true;
              $scope.state.searchSubmitted = true;
              $scope.state.searchType = 'teams';
              if (!paginate) {
                $scope.state.currentPage = 1;
                delete $scope.state.offset;
              }
              return TeamraiserTeamService.getTeams($httpParamSerializer(getSearchParams())).then(function(response) {
                var ref;
                if (response.data.errorResponse) {
                  $scope.state.searchResults = [];
                  $scope.state.errorMessage = response.data.errorResponse.message;
                } else {
                  $scope.state.searchResults = (ref = response.data.getTeamSearchByInfoResponse) != null ? ref.team : void 0;
                  $scope.state.totalResults = response.data.getTeamSearchByInfoResponse.totalNumberResults ? Number(response.data.getTeamSearchByInfoResponse.totalNumberResults) : 0;
                  if ($scope.state.searchResults) {
                    if (!angular.isArray($scope.state.searchResults)) {
                      $scope.state.searchResults = [$scope.state.searchResults];
                    }
                  }
                  $scope.state.errorMessage = !$scope.state.searchResults ? $scope.state.noResultsMsg : null;
                }
                return delete $scope.state.isLoading;
              });
            };
            return $scope.paginateResults = function(type) {
              $scope.state.offset = $scope.state.currentPage - 1;
              if (type === 'participants') {
                $scope.findParticipants(true);
              }
              if (type === 'teams') {
                return $scope.findTeams(true);
              }
            };
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('honorRoll', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/honorRoll.html',
        scope: {
          type: '@',
          sizeLimit: '@',
          id: '@',
          frId: '@',
          listData: '=?'
        },
        controller: [
          '$rootScope', '$scope', '$luminateTemplateTag', function($rootScope, $scope, $luminateTemplateTag) {
            var sizeLimit;
            $scope.frId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.list = 'loading';
            sizeLimit = $scope.sizeLimit ? $scope.sizeLimit : 100;
            if ($scope.listData) {
              $scope.list = $scope.listData;
              return $scope.$watch('listData', function(value) {
                return $scope.list = $scope.listData;
              });
            } else {
              $scope.list = [];
              if ($scope.type === 'participant') {
                $luminateTemplateTag.parse('[[S36:top_gifts_list,' + $scope.frId + ',0,' + $scope.id + ',LIST,SUM,' + $scope.sizeLimit + ',]] ').then(function(response) {
                  if (response.indexOf('<li>') > 0) {
                    return response.replace(/<li>(.*?)<\/li>/g, function(match, donor) {
                      donor = donor.replace('-&nbsp;', '');
                      donor = {
                        name: donor.split('&nbsp;')[0],
                        amountRaised: donor.split('&nbsp;')[1]
                      };
                      return $scope.list.push(donor);
                    });
                  }
                });
              }
              if ($scope.type === 'team') {
                return $luminateTemplateTag.parse('[[S36:team_donor_list,' + $scope.frId + ',' + $scope.id + ',0,LIST,SUM,' + $scope.sizeLimit + ',]] ').then(function(response) {
                  if (response.indexOf('<li>') > 0) {
                    return response.replace(/<li>(.*?)<\/li>/g, function(match, donor) {
                      donor = donor.replace('-&nbsp;', '');
                      donor = {
                        name: donor.split('&nbsp;')[0],
                        amountRaised: donor.split('&nbsp;')[1]
                      };
                      return $scope.list.push(donor);
                    });
                  }
                });
              }
            }
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('loadingIndicator', [
    'APP_INFO', function(APP_INFO) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/loadingIndicator.html',
        replace: true,
        scope: {
          size: '@',
          text: '@'
        },
        controller: [
          '$scope', function($scope) {
            return $scope.size = $scope.size ? $scope.size : 4;
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('loginForm', [
    'APP_INFO', function(APP_INFO) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/loginForm.html',
        scope: {
          layout: '@',
          showLables: '@',
          formSize: '@'
        },
        controller: [
          '$scope', '$httpParamSerializer', 'AuthService', function($scope, $httpParamSerializer, AuthService) {
            $scope.state = {
              errorMsg: null
            };
            $scope.layout = $scope.layout ? $scope.layout : 'vertical';
            $scope.showLables = $scope.showLables ? $scope.showLables : true;
            return $scope.loginUser = function() {
              if ($scope.loginForm.$valid) {
                return AuthService.login($httpParamSerializer($scope.loginUser)).then(function(response) {
                  if (response.data.errorResponse) {
                    return $scope.state.errorMsg = response.data.errorResponse.message;
                  } else if (response.data.loginResponse) {
                    return location.reload();
                  }
                });
              }
            };
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('participationTypes', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/participationTypes.html',
        scope: {
          frId: '@',
          layout: '@',
          participationTypesData: '=?'
        },
        controller: [
          '$rootScope', '$scope', 'TeamraiserRegistrationService', function($rootScope, $scope, TeamraiserRegistrationService) {
            var setPartType;
            $scope.frId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.state = {
              selectedParticipationType: null
            };
            $scope.participationTypes = 'loading';
            setPartType = function(types) {
              return $scope.participationTypes = types;
            };
            if ($scope.participationTypesData) {
              setPartType($scope.participationTypesData);
              return $scope.$watch('participationTypesData', function(value) {
                return setPartType($scope.participationTypesData);
              });
            } else {
              return TeamraiserRegistrationService.getParticipationTypes('fr_id=' + $scope.frId).then(function(response) {
                if (response.data.getParticipationTypesResponse) {
                  return setPartType(response.data.getParticipationTypesResponse.participationType);
                }
              });
            }
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('passwordReset', [
    'APP_INFO', function(APP_INFO) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/passwordReset.html',
        scope: {
          email: '@',
          type: '@',
          size: '@'
        },
        controller: [
          '$scope', 'AuthService', function($scope, AuthService) {
            $scope.type = $scope.type ? $scope.type : 'link';
            $scope.size = $scope.size ? $scope.size : 'md';
            $scope.state = {
              sendLogin: false,
              error: null
            };
            return $scope.forgotLogin = function() {
              if ($scope.email) {
                return AuthService.login('email=' + $scope.email + '&send_user_name=true').then(function(response) {
                  return $scope.state.sendLogin = true;
                });
              } else {
                return $scope.state.error = true;
              }
            };
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('progressBadges', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/progressBadges.html',
        scope: {
          frId: '@',
          type: '@',
          id: '@',
          customBadgeData: '=?'
        },
        controller: [
          '$scope', 'TeamraiserParticipantService', 'TeamraiserTeamService', function($scope, TeamraiserParticipantService, TeamraiserTeamService) {
            $scope.frId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.badges = {
              defaultBadges: [],
              customBadges: []
            };
            if ($scope.customBadgeData) {
              $scope.badges.customBadges = $scope.customBadges;
              return $scope.$watch('customBadgeData', function(value) {
                return $scope.badges.customBadges = value;
              });
            } else {
              if ($scope.type === 'individual') {
                TeamraiserParticipantService.getParticipants('&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + $scope.frId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id).then(function(response) {
                  var ref;
                  $scope.badges.defaultBadges = [(ref = response.data.getParticipantsResponse) != null ? ref.participant.badges : void 0];
                  if ($scope.badges.defaultBadges[0].participantMilestoneLargeBadgeUrl) {
                    $scope.badges.defaultBadges[0].participantMilestoneLargeBadgeUrl = $scope.badges.defaultBadges[0].participantMilestoneLargeBadgeUrl.replace('/lg_', '/');
                  }
                  if ($scope.badges.defaultBadges[0].personalDonationBadgeLargeUrl) {
                    return $scope.badges.defaultBadges[0].personalDonationBadgeLargeUrl = $scope.badges.defaultBadges[0].personalDonationBadgeLargeUrl.replace('/lg_', '/');
                  }
                });
              }
              if ($scope.type === 'team') {
                return TeamraiserTeamService.getTeams('team_id=' + $scope.id + '&fr_id=' + $scope.frId).then(function(response) {
                  var ref;
                  return $scope.badges.defaultBadges = [(ref = response.data.getTeamSearchByInfoResponse) != null ? ref.team.badges : void 0];
                });
              }
            }
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('progressMeter', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/progressMeter.html',
        scope: {
          type: '@',
          showMeterPercent: '@',
          frId: '@',
          id: '@',
          progressData: '=?'
        },
        controller: [
          '$rootScope', '$scope', '$filter', 'TeamraiserEventService', 'TeamraiserParticipantService', 'TeamraiserTeamService', 'TeamraiserCompanyService', function($rootScope, $scope, $filter, TeamraiserEventService, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) {
            var hideMeter, percent, setMeter;
            $scope.frId = $scope.frId ? $scope.frId : $rootScope.frId;
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
                TeamraiserEventService.getTeamRaiserData($scope.frId).then(function(response) {
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
                TeamraiserParticipantService.getParticipants('&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + $scope.frId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id).then(function(response) {
                  var participant;
                  if (response.data.getParticipantsResponse) {
                    participant = response.data.getParticipantsResponse.participant;
                    return setMeter(Number(participant.amountRaised), Number(participant.goal));
                  }
                });
              }
              if ($scope.type === 'team') {
                TeamraiserTeamService.getTeams('team_id=' + $scope.id + '&fr_id=' + $scope.frId).then(function(response) {
                  var team;
                  if (response.data.getTeamSearchByInfoResponse) {
                    team = response.data.getTeamSearchByInfoResponse.team;
                    return setMeter(Number(team.amountRaised), Number(team.goal));
                  }
                });
              }
              if ($scope.type === 'company') {
                return TeamraiserCompanyService.getCompanies('company_id=' + $scope.id + '&fr_id=' + $scope.frId).then(function(response) {
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

  angular.module('luminateControllers').directive('rosterList', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/rosterList.html',
        scope: {
          frId: '@',
          type: '@',
          id: '@',
          buttonSize: '@',
          includeSearch: '@',
          showBadges: '@',
          sortAscending: '@',
          sortColumn: '@',
          sizeLimit: '@',
          tableStripe: '@'
        },
        controller: [
          '$scope', '$httpParamSerializer', 'TeamraiserParticipantService', 'TeamraiserTeamService', function($scope, $httpParamSerializer, TeamraiserParticipantService, TeamraiserTeamService) {
            var getSearchParams, sizeLimit;
            $scope.frId = $scope.frId ? $scope.frId : $rootScope.frId;
            sizeLimit = $scope.sizeLimit ? $scope.sizeLimit : 25;
            $scope.state = {
              searchType: $scope.type === 'companyTeams' ? 'team' : 'participant',
              sortAscending: $scope.sortAscending ? $scope.sortAscending : false,
              sortColumn: $scope.sortColumn ? $scope.sortColumn : 'total',
              firstName: null,
              lastName: null,
              teamName: null,
              totalResults: 0,
              currentPage: 1,
              offset: null
            };
            getSearchParams = function() {
              var params;
              params = {
                list_page_size: $scope.sizeLimit ? $scope.sizeLimit : null,
                list_ascending: $scope.state.sortAscending,
                list_page_offset: $scope.state.offset ? $scope.state.offset : null,
                list_sort_column: $scope.state.searchType === 'participant' && $scope.state.sortColumn === 'name' ? 'first_name' : $scope.state.sortColumn,
                fr_id: $scope.frId,
                team_name: $scope.type === 'companyParticipants' ? '%%%' : null
              };
              if ($scope.state.searchType === 'participant') {
                params.first_name = $scope.state.firstName ? $scope.state.firstName : '%';
                params.last_name = $scope.state.lastName ? $scope.state.lastName : '%%';
                params.list_filter_column = $scope.type === 'teamParticipants' ? 'reg.team_id' : 'team.company_id';
                params.list_filter_text = $scope.id;
              } else {
                params.team_name = $scope.state.teamName ? $scope.state.teamName : '%%%';
                params.team_company_id = $scope.id;
              }
              return params;
            };
            $scope.findParticipants = function(paginate) {
              $scope.state.isLoading = true;
              $scope.state.list = [];
              if (!paginate) {
                $scope.state.currentPage = 1;
                delete $scope.state.offset;
              }
              return TeamraiserParticipantService.getParticipants($httpParamSerializer(getSearchParams())).then(function(response) {
                var participants, ref;
                if (response.data.errorResponse) {
                  $scope.state.errorMessage = response.data.errorResponse.message;
                } else {
                  participants = (ref = response.data.getParticipantsResponse) != null ? ref.participant : void 0;
                  if (participants) {
                    delete $scope.state.errorMessage;
                    $scope.state.totalResults = Number(response.data.getParticipantsResponse.totalNumberResults);
                    if (!angular.isArray(participants)) {
                      participants = [participants];
                    }
                    angular.forEach(participants, function(participant, key) {
                      var ref1;
                      if ((ref1 = participant.name) != null ? ref1.first : void 0) {
                        return $scope.state.list.push(participant);
                      }
                    });
                  } else {
                    $scope.state.errorMessage = 'No participants returned in your search';
                  }
                }
                return delete $scope.state.isLoading;
              });
            };
            $scope.findTeams = function(paginate) {
              $scope.state.isLoading = true;
              $scope.state.list = [];
              if (!paginate) {
                $scope.state.currentPage = 1;
                delete $scope.state.offset;
              }
              return TeamraiserTeamService.getTeams($httpParamSerializer(getSearchParams())).then(function(response) {
                var ref, teams;
                if (response.data.errorResponse) {
                  $scope.state.errorMessage = response.data.errorResponse.message;
                } else {
                  teams = (ref = response.data.getTeamSearchByInfoResponse) != null ? ref.team : void 0;
                  if (teams) {
                    delete $scope.state.errorMessage;
                    $scope.state.totalResults = Number(response.data.getTeamSearchByInfoResponse.totalNumberResults);
                    if (!angular.isArray(teams)) {
                      teams = [teams];
                    }
                    $scope.state.list = teams;
                  } else {
                    $scope.state.errorMessage = 'No teams returned in your search';
                  }
                }
                return delete $scope.state.isLoading;
              });
            };
            if ($scope.type === 'teamParticipants' || $scope.type === 'companyParticipants') {
              $scope.findParticipants(false);
            } else {
              $scope.findTeams(false);
            }
            $scope.paginateResults = function() {
              $scope.state.offset = $scope.state.currentPage - 1;
              if ($scope.state.searchType === 'participant') {
                return $scope.findParticipants(true);
              } else {
                return $scope.findTeams(true);
              }
            };
            return $scope.sortResults = function(sort) {
              $scope.state.sortAscending = !$scope.state.sortAscending;
              $scope.state.sortColumn = sort;
              if ($scope.state.searchType === 'participant') {
                return $scope.findParticipants(false);
              } else {
                return $scope.findTeams(false);
              }
            };
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').directive('topList', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'html/directive/topList.html',
        scope: {
          type: '@',
          sizeLimit: '@',
          showBadges: '@',
          id: '@',
          frId: '@',
          listData: '=?'
        },
        controller: [
          '$rootScope', '$scope', 'TeamraiserParticipantService', 'TeamraiserTeamService', 'TeamraiserCompanyService', function($rootScope, $scope, TeamraiserParticipantService, TeamraiserTeamService, TeamraiserCompanyService) {
            var setList, sizeLimit;
            $scope.frId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.list = 'loading';
            sizeLimit = $scope.sizeLimit ? $scope.sizeLimit : 25;
            setList = function(list) {
              return $scope.list = list;
            };
            if ($scope.listData) {
              $scope.list = $scope.listData;
              return $scope.$watch('listData', function(value) {
                return setList($scope.listData);
              });
            } else {
              if ($scope.type === 'participants') {
                TeamraiserParticipantService.getParticipants('&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.frId).then(function(response) {
                  var ref, topList, topParticipants;
                  topList = [];
                  topParticipants = (ref = response.data.getParticipantsResponse) != null ? ref.participant : void 0;
                  if (topParticipants) {
                    if (!angular.isArray(topParticipants)) {
                      topParticipants = [topParticipants];
                    }
                    angular.forEach(topParticipants, function(participant, key) {
                      var ref1;
                      if ((ref1 = participant.name) != null ? ref1.first : void 0) {
                        return topList.push(participant);
                      }
                    });
                  }
                  return setList(topList);
                });
              }
              if ($scope.type === 'teams') {
                TeamraiserTeamService.getTeams('team_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.frId).then(function(response) {
                  var ref;
                  return setList((ref = response.data.getTeamSearchByInfoResponse) != null ? ref.team : void 0);
                });
              }
              if ($scope.type === 'companies') {
                return TeamraiserCompanyService.getCompanies('company_name=' + encodeURIComponent('%%%') + '&list_sort_column=total&list_ascending=false&list_page_size=' + sizeLimit + '&fr_id=' + $scope.frId).then(function(response) {
                  var ref;
                  return setList((ref = response.data.getCompaniesResponse) != null ? ref.company : void 0);
                });
              }
            }
          }
        ]
      };
    }
  ]);

}).call(this);
