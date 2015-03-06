module.exports = (component, spec) ->
  return if !spec.query?
  component.query = (params) ->
    spec.query.call component, params