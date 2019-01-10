angular.module 'luminateControllers'
  .directive 'honorRoll', [
    'APP_INFO'
    '$rootScope'
    (APP_INFO, $rootScope) ->
      templateUrl: APP_INFO.rootPath + 'html/directive/honorRoll.html'
      scope:
        type: '@'
        sizeLimit: '@'
        id: '@'
        frId: '@'
        listData: '=?'
      controller: [
        '$rootScope'
        '$scope'
        '$luminateTemplateTag'
        ($rootScope, $scope, $luminateTemplateTag) ->
          $scope.frId = if $scope.frId then $scope.frId else $rootScope.frId
          $scope.list = 'loading'
          sizeLimit = if $scope.sizeLimit then $scope.sizeLimit else 100

          if $scope.listData
            $scope.list = $scope.listData
            $scope.$watch 'listData', (value) ->
              $scope.list = $scope.listData
          else
            $scope.list = []
            if $scope.type is 'participant'
              $luminateTemplateTag.parse '[[S36:top_gifts_list,' + $scope.frId + ',0,' + $scope.id + ',LIST,SUM,' + $scope.sizeLimit + ',]] '
                .then (response) ->
                  if response.indexOf('<li>') > 0
                    response.replace /<li>(.*?)<\/li>/g, (match, donor) ->
                      donor = donor.replace '-&nbsp;', ''
                      donor =
                        name: donor.split('&nbsp;')[0]
                        amountRaised: donor.split('&nbsp;')[1]
                      $scope.list.push donor
            if $scope.type is 'team'
              #TO DO - fix amount for team
              $luminateTemplateTag.parse '[[S36:team_donor_list,' + $scope.frId + ',' + $scope.id + ',0,LIST,SUM,' + $scope.sizeLimit + ',]] '
                .then (response) ->
                  if response.indexOf('<li>') > 0
                    response.replace /<li>(.*?)<\/li>/g, (match, donor) ->
                      donor = donor.replace '-&nbsp;', ''
                      donor =
                        name: donor.split('&nbsp;')[0]
                        amountRaised: donor.split('&nbsp;')[1]
                      $scope.list.push donor
      ]
  ]