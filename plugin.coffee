module.exports = (component, spec) ->
  if !spec.query?
    return component.query = -> {}
  component.query = (params) ->
    spec.query.call component, params