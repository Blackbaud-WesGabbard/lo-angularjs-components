angular.module 'luminateControllers'
  .directive 'donorTeamSearch', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/donorTeamSearch.html'
      scope:
        frId: '@'
        eventType: '@'
        sizeLimit: '@'
        sortAscending: '@'
        showBadges: '@'
      controller: [
        '$rootScope'
        '$scope'
        '$httpParamSerializer'
        'TeamraiserParticipantService'
        'TeamraiserTeamService'
        ($rootScope, $scope, $httpParamSerializer, TeamraiserParticipantService, TeamraiserTeamService) ->
          $scope.frId = if $scope.frId then $scope.frId else $rootScope.frId

          $scope.state =
            isLoading: false
            searchSubmitted: false
            searchType: null
            firstName: null
            lastName: null
            teamName: null
            errorMessage: null
            noResultsMsg: 'Your search returned no results.'
            searchResults: []
            totalResults: 0
            currentPage: 1
            offset: null

          getSearchParams =  ->
            params =
              list_page_size: if $scope.sizeLimit then $scope.sizeLimit else null
              list_ascending: if $scope.sortAscending then $scope.sortAscending else null
              list_page_offset: if $scope.state.offset then $scope.state.offset else null
              list_sort_column: if $scope.state.searchType is 'participants' then 'first_name' else 'name'
            if $scope.eventType
              params.event_type = $scope.eventType
            else if $scope.frId
              params.fr_id = $scope.frId
            if $scope.state.searchType is 'participants'
              params.first_name = if $scope.state.firstName then $scope.state.firstName else '%'
              params.last_name = if $scope.state.lastName then $scope.state.lastName else '%%'
              params.list_filter_column = 'private_page'
              params.list_filter_text = 0
            if $scope.state.searchType is 'teams'
              params.team_name = if $scope.state.teamName then $scope.state.teamName else '%%'
            params

          $scope.findParticipants = (paginate) ->
            $scope.state.isLoading = true
            $scope.state.searchSubmitted = true
            $scope.state.searchType = 'participants'
            if !paginate
              $scope.state.currentPage = 1
              delete $scope.state.offset
            $scope.searchTerm = if $scope.state.firstName then $scope.state.firstName else '%'
            TeamraiserParticipantService.getParticipants $httpParamSerializer getSearchParams()
              .then (response) ->
                if response.data.errorResponse
                  $scope.state.searchResults = []
                  $scope.state.errorMessage = response.data.errorResponse.message
                else
                  $scope.state.searchResults = response.data.getParticipantsResponse?.participant
                  $scope.state.totalResults = if response.data.getParticipantsResponse.totalNumberResults then Number response.data.getParticipantsResponse.totalNumberResults else 0
                  if $scope.state.searchResults
                    $scope.state.searchResults = [$scope.state.searchResults] if not angular.isArray $scope.state.searchResults
                  $scope.state.errorMessage = if !$scope.state.searchResults then $scope.state.noResultsMsg else null
                delete $scope.state.isLoading

          $scope.findTeams = (paginate) ->
            $scope.state.isLoading = true
            $scope.state.searchSubmitted = true
            $scope.state.searchType = 'teams'
            if !paginate
              $scope.state.currentPage = 1
              delete $scope.state.offset
            TeamraiserTeamService.getTeams $httpParamSerializer getSearchParams()
              .then (response) ->
                if response.data.errorResponse
                  $scope.state.searchResults = []
                  $scope.state.errorMessage = response.data.errorResponse.message
                else
                  $scope.state.searchResults = response.data.getTeamSearchByInfoResponse?.team
                  $scope.state.totalResults = if response.data.getTeamSearchByInfoResponse.totalNumberResults then Number response.data.getTeamSearchByInfoResponse.totalNumberResults else 0
                  if $scope.state.searchResults
                    $scope.state.searchResults = [$scope.state.searchResults] if not angular.isArray $scope.state.searchResults
                  $scope.state.errorMessage = if !$scope.state.searchResults then $scope.state.noResultsMsg else null
                delete $scope.state.isLoading

          $scope.paginateResults = (type) ->
            $scope.state.offset = $scope.state.currentPage - 1
            if type is 'participants'
              $scope.findParticipants true
            if type is 'teams'
              $scope.findTeams true
      ]
  ]