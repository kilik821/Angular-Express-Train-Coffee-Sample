module = angular.module 'myApp.controllers', []

module.controller 'IndexCtrl', ['$scope', '$http', ($scope, $http) -> ]


module.controller 'LoginCtrl', ['$scope', '$http', '$rootScope', '$location', ($scope, $http, $rootScope, $location) ->
  $scope.user = {}
  $scope.statusMessage = ""

  #figure out where we should redirect to once the user has logged in.
  $rootScope.redirect = "/todos"  if not $rootScope.redirect or $rootScope.redirect is "/login"
  $scope.submit = (user) ->
    $http.post("/user/login", $scope.user).success((data) ->
      $rootScope.user.username = $scope.user.username
      $location.path $rootScope.redirect
    ).error (data, status, headers, config) ->
      $scope.statusMessage = data
]

module.controller 'RegisterCtrl', ['$scope', '$http', '$rootScope', '$location', ($scope, $http, $rootScope, $location) ->
  $scope.user = {}
  $scope.statusMessage = ""
  $scope.submit = (user) ->
    $http.post("/user/register", $scope.user).success((data) ->
      $rootScope.user.username = $scope.user.username
      $location.path "/todos"
    ).error (data, status, headers, config) ->
      $scope.statusMessage = data
]

TodosCtrl = ($scope, $http, Todo) ->

  #get the todos from server

  #function to create a new Todo object

  #we'll call this function when the checkbox of a todo is checked

  #remove complete todos
  #delete on server
  #remove from client
  getTodosFromServer = ->
    Todo.query (data) ->
      $scope.todos = data

  getTodosFromServer()
  $scope.newTodo = {}
  $scope.createTodo = (todo) ->
    return  if $scope.newTodoForm.$invalid
    Todo.save {}, $scope.newTodo, ((data) ->
      $scope.todos.push data
      $scope.statusMessage = ""
      $scope.newTodo = {}
    ), (data, status, headers, config) ->
      $scope.statusMessage = data


  $scope.markComplete = (todo) ->
    todo.$save id: todo._id

  $scope.removeComplete = ->
    $scope.todos.forEach (todo) ->
      if todo.complete
        todo.$delete
          id: todo._id
        , ->
          $scope.todos.splice $scope.todos.indexOf(todo), 1
