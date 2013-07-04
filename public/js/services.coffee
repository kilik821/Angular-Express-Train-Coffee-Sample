"use strict"
angular.module("myApp.services", ["ngResource"]).factory "Todo", ($resource) ->
  $resource "api/Todo/:id", {}, {}

