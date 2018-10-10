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
      return $rootScope.frId = 1070;
    }
  ]);

  angular.module('ngLuminateLibrary').config([
    '$luminateUtilsConfigProvider', function($luminateUtilsConfigProvider) {
      $luminateUtilsConfigProvider.setPath({
        nonsecure: 'http://psdemo.convio.net/site/',
        secure: 'https://secure2.convio.net/psdemo/site/'
      }).setKey('wDB09SQODRpVIOvX');
    }
  ]);

  angular.module('ngLuminateLibrary').factory('TeamraiserEventService', [
    '$rootScope', '$luminateTemplateTag', function($rootScope, $luminateTemplateTag) {
      return {
        getTeamRaiserData: function(frId) {
          var teamraiserData;
          console.log(frId);
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
          dataString = 'method=getParticipants&first_name=' + encodeURIComponent('%') + '&last_name=' + encodeURIComponent('%') + '&list_sort_column=total&list_ascending=false&list_page_size=500';
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString
          }).then(function(response) {
            var participants, ranking, ref;
            ranking = {};
            participants = (ref = response.data.getParticipantsResponse) != null ? ref.participant : void 0;
            if (participants) {
              if (!angular.isArray(participants)) {
                participants = [participants];
              }
              ranking = {
                rank: 0,
                total: 0
              };
              angular.forEach(participants, function(participant, key) {
                ranking.total++;
                if (participant.consId === String(consId)) {
                  return ranking = {
                    rank: key + 1,
                    total: ranking.total,
                    amountRaised: $filter('currency')(participant.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace('.00', ''),
                    amountRaisedFormatted: $filter('currency')(participant.amountRaised / 100, '$').replace('.00', ''),
                    goal: $filter('currency')(participant.goal / 100, '$').replace('$', '').replace(/,/g, '').replace('.00', ''),
                    goalFormatted: $filter('currency')(participant.goal / 100, '$').replace('.00', ''),
                    name: participant.name.first + ' ' + participant.name.last,
                    consId: participant.consId,
                    pageUrl: $luminateUtilsConfig.path.secure + 'TR?fr_id=' + $rootScope.frId + '&pg=personal&px=' + participant.consId,
                    donationUrl: participant.donationUrl,
                    aTeamCaptain: participant.aTeamCaptain,
                    teamName: participant.teamName,
                    teamPageUrl: participant.teamPageUrl
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

  angular.module('ngLuminateLibrary').factory('TeamraiserTeamService', [
    '$rootScope', '$filter', '$luminateRest', '$luminateUtilsConfig', function($rootScope, $filter, $luminateRest, $luminateUtilsConfig) {
      return {
        updateTeamInformation: function(requestData) {
          var dataString;
          dataString = 'method=updateTeamInformation&fr_id=' + $rootScope.frId;
          if (requestData && requestData !== '') {
            dataString += '&' + requestData;
          }
          return $luminateRest.request({
            api: 'teamraiser',
            data: dataString,
            requiresAuth: true
          });
        },
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
                    total: Number(totalTeams),
                    amountRaised: $filter('currency')(team.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace('.00', ''),
                    amountRaisedFormatted: $filter('currency')(team.amountRaised / 100, '$').replace('.00', ''),
                    name: team.name,
                    numMembers: team.numMembers,
                    teamId: team.id,
                    pageUrl: $luminateUtilsConfig.path.secure + 'TR?fr_id=' + $rootScope.frId + '&pg=team&team_id=' + team.id
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

  angular.module('luminateControllers').controller('MainCtrl', [
    '$rootScope', '$scope', function($rootScope, $scope) {
      console.log($rootScope.frId);
      return $scope.ctrl = {
        hide: false,
        frId: 1070,
        consId: 1001491
      };
    }
  ]);

  angular.module('luminateControllers').directive('progressMeter', [
    'APP_INFO', '$rootScope', function(APP_INFO, $rootScope) {
      return {
        templateUrl: APP_INFO.rootPath + 'dist/html/directive/progressMeter.html',
        scope: {
          type: '@',
          showMeterPercent: '=',
          id: '@',
          frId: '@',
          progressData: '=?'
        },
        controller: [
          '$rootScope', '$scope', '$filter', 'APP_INFO', 'TeamraiserEventService', 'TeamraiserParticipantService', 'TeamraiserTeamService', function($rootScope, $scope, $filter, APP_INFO, TeamraiserEventService, TeamraiserParticipantService, TeamraiserTeamService) {
            var eventId, setMeter;
            eventId = $scope.frId ? $scope.frId : $rootScope.frId;
            $scope.meter = {
              goal: 0,
              dollars: 0,
              percent: 0,
              hideMeter: null
            };
            setMeter = function(amount, goal, hide) {
              return $scope.meter = {
                dollars: amount,
                goal: goal,
                percent: amount / goal,
                hideMeter: hide
              };
            };
            if ($scope.progressData) {
              return console.log($scope.progressData, 'test');
            } else {
              console.log('no data');
              if ($scope.type === 'individual') {
                TeamraiserParticipantService.getParticipants('&first_name=' + encodeURIComponent('%%') + '&last_name=' + encodeURIComponent('%') + '&list_page_size=1&fr_id=' + eventId + '&list_filter_column=reg.cons_id&list_filter_text=' + $scope.id).then(function(response) {
                  var participant;
                  if (response.data.getParticipantsResponse) {
                    participant = response.data.getParticipantsResponse.participant;
                    return $scope.meter = {
                      percent: String(Math.round((participant.amountRaised / participant.goal) * 100)) + '%',
                      goal: $filter('currency')(participant.goal / 100, '$').replace('.00', ''),
                      dollars: $filter('currency')(participant.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace('.00', ''),
                      dollarsFormatted: $filter('currency')(participant.amountRaised / 100, '$').replace('.00', '')
                    };
                  }
                });
              }
              if ($scope.type === 'event') {
                console.log('is event');
                return TeamraiserEventService.getTeamRaiserData(eventId).then(function(response) {
                  var rawDollars, rawGoal, rawPercent, teamraiser;
                  if (response.teamraiser) {
                    teamraiser = response.teamraiser;
                    $scope.meter.goal = teamraiser.goal.replace('.00', '');
                    $scope.meter.dollars = teamraiser.dollars.replace('.00', '');
                    rawGoal = Number($scope.meter.goal.replace(/[^\d.]/g, ''));
                    rawDollars = Number($scope.meter.dollars.replace(/[^\d.]/g, ''));
                    rawPercent = (rawDollars / rawGoal) * 100;
                    $scope.meter.percent = String(Math.round((rawDollars / rawGoal) * 100)) + '%';
                    if (rawPercent < $scope.showMeterPercent) {
                      return $scope.meter.hideMeter = true;
                    }
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
