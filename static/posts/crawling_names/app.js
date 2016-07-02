var App = angular.module('App', []);

App.controller('NamesCtrl', function($scope, $http) {
  $http.get('dump.json')
       .then(function(res){
          $scope.names = res.data;
        });
  $scope.names_filter = function(value, index) {
    if(!$scope.girls && value['gender'] == 'دختر')
      return false;
    if(!$scope.boys && value['gender'] == 'پسر')
      return false;
    if($scope.non_arabic &&
      (-1 != value['meaning'].indexOf('عربي') ||
      -1 != value['meaning'].indexOf('عربی')))
      return false;
    if($scope.non_hebrew && 
      (-1 != value['meaning'].indexOf('عبری') ||
      -1 != value['meaning'].indexOf('عبري')))
      return false;
    return value;
  };
  $scope.girls = false;
  $scope.boys = true;
  $scope.non_arabic = true;
  $scope.non_hebrew = true;
});
