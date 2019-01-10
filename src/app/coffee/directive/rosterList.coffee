angular.module 'luminateControllers'
  .directive 'rosterList', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/rosterList.html'
      scope:
        frId: '@'
        type: '@'
        id: '@'
        buttonSize: '@'
        includeSearch: '@'
        showBadges: '@'
        sortAscending: '@'
        sortColumn: '@'
        sizeLimit: '@'
        tableStripe: '@'
      controller: [
        '$scope'
        '$httpParamSerializer'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        ($scope, $httpParamSerializer, TeamraiserParticipantService, TeamraiserTeamService) ->
          $scope.frId = if $scope.frId then $scope.frId else $rootScope.frId
          sizeLimit = if $scope.sizeLimit then $scope.sizeLimit else 25
          $scope.state =
            searchType: if $scope.type is 'companyTeams' then 'team' else 'participant'
            sortAscending: if $scope.sortAscending then $scope.sortAscending else false
            sortColumn: if $scope.sortColumn then $scope.sortColumn else 'total'
            firstName: null
            lastName: null
            teamName: null
            totalResults: 0
            currentPage: 1
            offset: null

          getSearchParams = ->
            params = 
              list_page_size: if $scope.sizeLimit then $scope.sizeLimit else null
              list_ascending: $scope.state.sortAscending
              list_page_offset: if $scope.state.offset then $scope.state.offset else null
              list_sort_column: if $scope.state.searchType is 'participant' and $scope.state.sortColumn is 'name' then 'first_name' else $scope.state.sortColumn
              fr_id: $scope.frId
              team_name: if $scope.type is 'companyParticipants' then '%%%' else null
            if $scope.state.searchType is 'participant'
              params.first_name = if $scope.state.firstName then $scope.state.firstName else '%'
              params.last_name = if $scope.state.lastName then $scope.state.lastName else '%%'
              params.list_filter_column = if $scope.type is 'teamParticipants' then 'reg.team_id' else 'team.company_id'
              params.list_filter_text = $scope.id
            else
              params.team_name = if $scope.state.teamName then $scope.state.teamName else '%%%'
              params.team_company_id = $scope.id
            params

          $scope.findParticipants = (paginate) ->
            $scope.state.isLoading = true
            $scope.state.list = []
            if !paginate
              $scope.state.currentPage = 1
              delete $scope.state.offset
            TeamraiserParticipantService.getParticipants $httpParamSerializer getSearchParams()
              .then (response) ->
                if response.data.errorResponse
                  $scope.state.errorMessage = response.data.errorResponse.message
                else
                  participants = response.data.getParticipantsResponse?.participant
                  if participants
                    delete $scope.state.errorMessage
                    $scope.state.totalResults = Number response.data.getParticipantsResponse.totalNumberResults
                    participants = [participants] if not angular.isArray participants
                    angular.forEach participants, (participant, key) ->
                      if participant.name?.first
                        $scope.state.list.push participant
                  else
                    $scope.state.errorMessage = 'No participants returned in your search'
                delete $scope.state.isLoading

          $scope.findTeams = (paginate) ->
            $scope.state.isLoading = true
            $scope.state.list = []
            if !paginate
              $scope.state.currentPage = 1
              delete $scope.state.offset
            TeamraiserTeamService.getTeams $httpParamSerializer getSearchParams()
              .then (response) ->
                if response.data.errorResponse
                  $scope.state.errorMessage = response.data.errorResponse.message
                else
                  teams = response.data.getTeamSearchByInfoResponse?.team
                  if teams
                    delete $scope.state.errorMessage
                    $scope.state.totalResults = Number response.data.getTeamSearchByInfoResponse.totalNumberResults
                    teams = [teams] if not angular.isArray teams
                    $scope.state.list = teams
                  else
                    $scope.state.errorMessage = 'No teams returned in your search'
                delete $scope.state.isLoading
                
          if $scope.type is 'teamParticipants' or $scope.type is 'companyParticipants'
            $scope.findParticipants false
          else
            $scope.findTeams false

          $scope.paginateResults = ->
            $scope.state.offset = $scope.state.currentPage - 1
            if $scope.state.searchType is 'participant'
              $scope.findParticipants true
            else
              $scope.findTeams true
          
          $scope.sortResults = (sort) ->
            $scope.state.sortAscending = !$scope.state.sortAscending
            $scope.state.sortColumn = sort
            if $scope.state.searchType is 'participant'
              $scope.findParticipants false
            else
              $scope.findTeams false
      ]
  ]