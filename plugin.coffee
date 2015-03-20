relay = require './relay'

module.exports = (component, spec) ->
  if !spec.query?
    return component.query = -> {}
  component.query = (params) ->
    spec.query.call component, params
  component.relay = (el, store) ->
    relay el, component, store