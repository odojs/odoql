module.exports = (component, spec) ->
  return if !spec.query?
  component.query = (params) ->
    spec.query.call component, params
  component.relay = (el, store, params) ->
    query = component.query params
    console.log query
    state = store query
    scene = component.mount el, state, params
    update: (params) ->
      query = component.query params
      state = store query
      scene.update state, params
    apply: (params) ->
      query = component.query params
      state = store query
      scene.apply state, params
    unmount: ->
      scene.unmount()