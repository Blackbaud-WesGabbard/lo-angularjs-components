(function() {
  var appDependencies;

  appDependencies = ['luminateControllers', 'ui.bootstrap'];

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

  angular.module('trControllers').directive('trThermometers', [
    'NG_APP_INFO', '$rootScope', function(NG_APP_INFO, $rootScope) {
      return {
        templateUrl: NG_APP_INFO.rootPath + 'dist/html/directive/trThermometers.html',
        controller: [
          '$rootScope', '$scope', '$attrs', '$uibModal', '$filter', 'NG_APP_INFO', 'TeamraiserDataService', 'TeamraiserParticipantService', 'TeamraiserRegistrationService', 'TeamraiserTeamService', 'TeamraiserSuggestionService', function($rootScope, $scope, $attrs, $uibModal, $filter, NG_APP_INFO, TeamraiserDataService, TeamraiserParticipantService, TeamraiserRegistrationService, TeamraiserTeamService, TeamraiserSuggestionService) {
            $scope.path = NG_APP_INFO.rootPath;
            $scope.type = $attrs.type;
            $scope.attrs = $attrs;
            $scope.location = $attrs.location ? $scope.$eval($attrs.location) : null;
            $scope.thermometer = {
              isLoading: true,
              goal: 0,
              dollars: 0,
              dollarsFormatted: 0,
              message: null,
              prevYear: '',
              prevDollars: 0,
              prevTeams: 0,
              prevParticipants: 0,
              hideTherm: false
            };
            if ($attrs.raised && $attrs.goal && $attrs.percent) {
              $scope.thermometer = {
                goal: $filter('currency')(Number($scope.$eval($attrs.goal)) / 100, '$').replace('.00', ''),
                dollars: $filter('currency')(Number($scope.$eval($attrs.raised)) / 100, '$').replace('$', '').replace(/,/g, '').replace('.00', ''),
                dollarsFormatted: $filter('currency')(Number($scope.$eval($attrs.raised)) / 100, '$').replace('.00', ''),
                percent: $scope.$eval($attrs.percent) + '%',
                rank: $scope.$eval($attrs.rank),
                total: $scope.$eval($attrs.total),
                daysLeft: $scope.$eval($attrs.daysLeft),
                teamMembers: $scope.$eval($attrs.teamMembers),
                teamCount: $scope.$eval($attrs.teamCount),
                participantCount: $scope.$eval($attrs.participantCount),
                hideTherm: $scope.$eval($attrs.hideTherm) === '0' ? true : false
              };
            } else {
              if ($attrs.type === 'individual') {
                TeamraiserParticipantService.getParticipants('&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + $rootScope.frId + '&list_filter_column=reg.cons_id&list_filter_text=' + $rootScope.consId).then(function(response) {
                  var participant;
                  if (response.data.getParticipantsResponse) {
                    participant = response.data.getParticipantsResponse.participant;
                    return $scope.thermometer = {
                      percent: String(Math.round((participant.amountRaised / participant.goal) * 100)) + '%',
                      goal: $filter('currency')(participant.goal / 100, '$').replace('.00', ''),
                      dollars: $filter('currency')(participant.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace('.00', ''),
                      dollarsFormatted: $filter('currency')(participant.amountRaised / 100, '$').replace('.00', '')
                    };
                  }
                });
              }
              if ($attrs.type === 'event') {
                $scope.thermometer.message = 'reus_' + $rootScope.pagenamePrefix + 'thermometer_text';
                TeamraiserDataService.getTeamRaiserData().then(function(response) {
                  var rawDollars, rawGoal, rawPercent, teamraiser;
                  if (response.teamraiser) {
                    teamraiser = response.teamraiser;
                    $scope.thermometer.goal = teamraiser.goal;
                    $scope.thermometer.dollars = teamraiser.dollars;
                    $scope.thermometer.dollarsFormatted = teamraiser.dollars;
                    $scope.thermometer.prevDollars = teamraiser.prevDollars;
                    $scope.thermometer.prevParticipants = teamraiser.prevParticipants;
                    $scope.thermometer.prevTeams = teamraiser.prevTeams;
                    if (teamraiser.prevEventDate !== '') {
                      $scope.thermometer.prevYear = teamraiser.prevEventDate.split('/')[2];
                    }
                    rawGoal = Number($scope.thermometer.goal.replace(/[^\d.]/g, ''));
                    rawDollars = Number($scope.thermometer.dollars.replace(/[^\d.]/g, ''));
                    if (rawGoal > 0 && rawDollars > 0) {
                      rawPercent = (rawDollars / rawGoal) * 100;
                      $scope.thermometer.percent = String(Math.round((rawDollars / rawGoal) * 100)) + '%';
                      if (rawPercent < 25 && teamraiser.prevFrId !== 'Unrecognized type parameter') {
                        $scope.thermometer.showPrevYear = true;
                      }
                    } else {
                      if (teamraiser.prevFrId !== 'Unrecognized type parameter') {
                        $scope.thermometer.showPrevYear = true;
                      }
                    }
                  }
                  return delete $scope.thermometer.isLoading;
                });
              }
            }
            $scope.refreshFundraisingProgress = function() {
              return TeamraiserParticipantService.getParticipantProgress('fr_id=' + $rootScope.frId).then(function(response) {
                var participantProgress, ref, ref1, ref2, ref3, teamProgress;
                participantProgress = response.data.getParticipantProgressResponse.personalProgress;
                if ((((ref = $scope.participantRegistration) != null ? ref.teamId : void 0) && ((ref1 = $scope.participantRegistration) != null ? ref1.teamId : void 0) !== '-1') || ((ref2 = $rootScope.dashboard) != null ? (ref3 = ref2.registration) != null ? ref3.teamId : void 0 : void 0)) {
                  teamProgress = response.data.getParticipantProgressResponse.teamProgress;
                }
                $scope.thermometer.goal = $scope.type === 'team' ? $filter('currency')(Number(teamProgress.goal) / 100, '$').replace('.00', '') : $filter('currency')(Number(participantProgress.goal) / 100, '$').replace('.00', '');
                $scope.thermometer.percent = $scope.type === 'team' ? teamProgress.percent + '%' : participantProgress.percent + '%';
                if (!$scope.$$phase) {
                  $scope.$apply();
                }
                return response;
              });
            };
            $scope.editGoalOptions = {
              updateGoalSuccess: false,
              updateGoalFailure: false,
              updateGoalFailureMessage: '',
              updateGoalInput: null
            };
            $scope.closeGoalAlerts = function(closeModal) {
              $scope.editGoalOptions.updateGoalSuccess = false;
              $scope.editGoalOptions.updateGoalFailure = false;
              $scope.editGoalOptions.updateGoalFailureMessage = '';
              if (closeModal) {
                return $scope.cancelEditGoal();
              }
            };
            $scope.editGoal = function(goalType) {
              $scope.closeGoalAlerts(false);
              $scope.editGoalOptions.updateGoalInput = null;
              return $scope.editGoalModal = $uibModal.open({
                scope: $scope,
                templateUrl: NG_APP_INFO.rootPath + 'dist/html/modal/trpc-edit' + goalType + 'Goal.html',
                size: 'sm'
              });
            };
            $scope.cancelEditGoal = function() {
              return $scope.editGoalModal.close();
            };
            return $scope.updateGoal = function(goalType) {
              var dataStr;
              switch (goalType) {
                case 'Participant':
                  dataStr = 'fr_id=' + $rootScope.frId + '&goal=' + (100 * $scope.editGoalOptions.updateGoalInput).toString();
                  return TeamraiserRegistrationService.updateRegistration(dataStr).then(function(response) {
                    var ref;
                    if (response.data.errorResponse) {
                      $scope.editGoalOptions.updateGoalFailure = true;
                      if (response.data.errorResponse.message) {
                        $scope.editGoalOptions.updateGoalFailureMessage = response.data.errorResponse.message;
                      } else {
                        $scope.editGoalOptions.updateGoalFailureMessage = 'An unexpected error occurred.';
                      }
                    } else {
                      $scope.editGoalOptions.updateGoalSuccess = true;
                      $scope.refreshFundraisingProgress();
                      $scope.closeGoalAlerts(true);
                      if ((ref = $rootScope.facebookFundraiserConfig) != null ? ref.fundraiserId : void 0) {
                        FacebookFundraiserService.updateFundraiser().then(function() {
                          return FacebookFundraiserService.syncDonations();
                        });
                      }
                    }
                    return response;
                  });
                case 'Team':
                  dataStr = 'team_goal=' + (100 * $scope.editGoalOptions.updateGoalInput).toString();
                  return TeamraiserTeamService.updateTeamInformation(dataStr).then(function(response) {
                    if (response.data.errorResponse) {
                      $scope.editGoalOptions.updateGoalFailure = true;
                      if (response.data.errorResponse.message) {
                        $scope.editGoalOptions.updateGoalFailureMessage = response.data.errorResponse.message;
                      } else {
                        $scope.editGoalOptions.updateGoalFailureMessage = 'An unexpected error occurred.';
                      }
                    } else {
                      $scope.editGoalOptions.updateGoalSuccess = true;
                      $scope.refreshFundraisingProgress();
                      $scope.closeGoalAlerts(true);
                      TeamraiserSuggestionService.dismissSuggestion('RaiseTeamGoal');
                    }
                    return response;
                  });
              }
            };
          }
        ]
      };
    }
  ]);

  angular.module('luminateControllers').controller('MainCtrl', [
    '$rootScope', '$scope', '$location', function($rootScope, $scope, $location) {
      console.log('main ctrl');
      $rootScope.$location = $location;
      return $rootScope.baseUrl = $location.absUrl().split('#')[0];
    }
  ]);

}).call(this);
