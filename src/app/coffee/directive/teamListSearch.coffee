angular.module 'luminateControllers'
  .directive 'teamListSearch', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/teamListSearch.html'
      scope:
        frId: '@'
        buttonSize: '@'
        captainSearch: '@'
        pagination: '@'
        sortAscending: '@'
        sortColumn: '@'
        sizeLimit: '@'
        tableStripe: '@'
      controller: [
        '$scope'
        '$httpParamSerializer'
        'TeamraiserTeamService'
        ($scope, $httpParamSerializer, TeamraiserTeamService) ->
          $scope.frId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.state =
            sizeLimit: if $scope.sizeLimit then $scope.sizeLimit else 25
            sortAscending: if $scope.sortAscending then $scope.sortAscending else true
            sortColumn: if $scope.sortColumn then $scope.sortColumn else 'name'
            firstName: null
            lastName: null
            teamName: null
            totalResults: 0
            currentPage: 1
            offset: 0

          getSearchParams = ->
            params =
              list_page_size: if $scope.state.sizeLimit then $scope.state.sizeLimit else null
              list_ascending: $scope.state.sortAscending
              list_page_offset: if $scope.state.offset then $scope.state.offset else 0
              list_sort_column: if $scope.state.searchType is 'participant' and $scope.state.sortColumn is 'name' then 'first_name' else $scope.state.sortColumn
              fr_id: $scope.frId
              team_name: $scope.state.teamName
              first_name: $scope.state.firstName
              last_name: $scope.state.lastName
            params

          processSearch = (paginate, concat) ->
            $scope.state.isLoading = true
            if !concat
              $scope.state.list = []
            if !paginate
              $scope.state.currentPage = 1
              $scope.state.offset = 0
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
                    if !concat
                      $scope.state.list = teams
                    else
                      newTotal = $scope.state.list.concat(teams)
                      $scope.state.list = newTotal
                  else
                    $scope.state.errorMessage = 'No teams returned in your search'
                return $scope.state

          processSearch false
            .then ->
              delete $scope.state.isLoading

          $scope.findTeams = (paginate, concat) ->
            processSearch paginate, concat
              .then ->
                delete $scope.state.isLoading

          $scope.paginateResults = ->
            $scope.state.offset = $scope.state.currentPage - 1
            processSearch true
              .then ->
                delete $scope.state.isLoading

          $scope.sortResults = (sort) ->
            $scope.state.sortAscending = !$scope.state.sortAscending
            $scope.state.sortColumn = sort
            processSearch false
              .then ->
                delete $scope.state.isLoading

          $scope.viewAll = (clear) ->
            $scope.state.sizeLimit = 500
            if !clear
              $scope.state.offset++
              concat = true
            else
              concat = false
              $scope.state.list = []
            processSearch true, concat
              .then (response) ->
                if response.totalResults > response.list.length
                  $scope.viewAll(false)
                else
                  delete $scope.state.isLoading
      ]
  ]
