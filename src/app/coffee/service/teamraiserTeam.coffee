angular.module 'ngLuminateLibrary'
  .factory 'TeamraiserTeamService', [
    '$luminateRest'
    ($luminateRest) ->
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
                  totalTeams: Number totalTeams
                  teamInfo: team
          ranking
  ]