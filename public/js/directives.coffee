"use strict"

# Directives 
angular.module("myApp.directives", []).directive("appVersion", ["version", (version) ->
  (scope, elm, attrs) ->
    elm.text version
]).directive "dropdown", ->
  (scope, elm, attrs) ->
    $(elm).dropdown()

