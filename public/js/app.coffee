#= require ./lib/angular/angular
#= require ./lib/angular/angular-resource
#= require ./lib/angular/angular-cookies
#= require ./lib/angular/angular-loader
#= require ./lib/angular/angular
#= require ./controllers
#= require ./directives
#= require ./services
#= require ./filters

"use strict"

# Declare app level module which depends on filters, and services

#The routes that our angular app will handle

#gets rid of the # in urls

#
#         Set up an interceptor to watch for 401 errors.
#         The server, rather than redirect to a login page (or whatever), just returns  a 401 error
#         if it receives a request that should have a user session going.  Angular catches the error below
#         and says what happens - in this case, we just redirect to a login page.  You can get a little more
#         complex with this strategy, such as queueing up failed requests and re-trying them once the user logs in.
#         Read all about it here: http://www.espeo.pl/2012/02/26/authentication-in-angularjs-application
#         
# save the current url so we can redirect the user back
angular.module("myApp", ["myApp.filters", "myApp.services", "myApp.directives", "myApp.controllers"]).config(["$routeProvider", "$locationProvider", "$httpProvider", ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider.when("/",
    templateUrl: "/partials/index"
    controller: 'IndexCtrl'
  ).when("/login",
    templateUrl: "/partials/login"
  ).when("/todos",
    templateUrl: "/partials/todos"
    controller: 'TodosCtrl'
  ).otherwise templateUrl: "/partials/404"
  $locationProvider.html5Mode true
  interceptor = ["$q", "$location", "$rootScope", ($q, $location, $rootScope) ->
    success = (response) ->
      response
    error = (response) ->
      status = response.status
      if status is 401
        $rootScope.redirect = $location.url()
        $rootScope.user = {}
        $location.path "/login"
      $q.reject response
    (promise) ->
      promise.then success, error
  ]
  $httpProvider.responseInterceptors.push interceptor
]).run ($rootScope, $http, $location) ->
  
  #global object representing the user who is logged in
  $rootScope.user = {}
  
  #as the app spins up, let's check to see if we have an active session with the server
  $http.get("/user").success((data) ->
    $rootScope.user.username = data.username
  ).error (data) ->

  
  #global function for logging out a user
  $rootScope.logout = ->
    $rootScope.user = {}
    $http.post "user/logout", {}
    $location.path "/"

