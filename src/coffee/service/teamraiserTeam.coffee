angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserTeamService', [
    '$rootScope'
    '$filter'
    '$luminateRest'
    '$luminateUtilsConfig'
    ($rootScope, $filter, $luminateRest, $luminateUtilsConfig) ->
      updateTeamInformation: (requestData) ->
        dataString = 'method=updateTeamInformation&fr_id=' + $rootScope.frId
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
          requiresAuth: true

      getTeams: (requestData) ->
        dataString = 'method=getTeamsByInfo'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString
          requiresAuth: true

      getTeamDivisions: (requestData) ->
        dataString = 'method=getTeamDivisions'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          data: dataString

      getTeamRank: (requestData, teamId) ->
        dataString = 'method=getTeamsByInfo&first_name=%25&last_name=%25&list_sort_column=total&list_ascending=false&list_page_size=500'
        dataString += '&' + requestData if requestData and requestData isnt ''
        $luminateRest.request
          api: 'teamraiser'
          requiresAuth: true
          data: dataString
        .then (response) ->
          ranking = {}
          totalTeams = response.data.getTeamSearchByInfoResponse?.totalNumberResults
          teams = response.data.getTeamSearchByInfoResponse?.team
          if teams
            teams = [teams] if not angular.isArray teams
            ranking =
              rank: 0
              total: Number totalTeams
            angular.forEach teams, (team, key) ->
              if team.id is String teamId
                ranking =
                  rank: key + 1
                  total: Number totalTeams
                  amountRaised: $filter('currency')(team.amountRaised / 100, '$').replace('$', '').replace(/,/g, '').replace '.00', ''
                  amountRaisedFormatted: $filter('currency')(team.amountRaised / 100, '$').replace '.00', ''
                  name: team.name
                  numMembers: team.numMembers
                  teamId: team.id
                  pageUrl: $luminateUtilsConfig.path.secure + 'TR?fr_id=' + $rootScope.frId + '&pg=team&team_id=' + team.id
          ranking
  ]