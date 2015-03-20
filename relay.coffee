extend = require 'extend'

module.exports = (el, component, store) ->
  scene = null
  
  memory = {}
  query = {}
  state = {}
  
  # TODO: Eventually support optimistic updates - data changes that are temp applied on top of state while an ajax request is processing, eventually merging into state once the request has finished or removed from state if the request failed. Similar to a copy on write file system.
  Relay =
    mount: ->
      scene = component.mount el, state, memory
    
    update: (params, cb) ->
      Relay.refreshAll params, (err) ->
        if err?
          cb err if cb?
          return
        if !scene?
          Relay.mount()
        else
          scene.update state, memory
        return cb() if cb?
    
    refreshAll: (params, cb) ->
      Relay.updateParams params
      Relay.executeQuery cb
    
    updateParams: (params) ->
      extend memory, params
    
    # TODO: better timing
    executeQuery: (cb) ->
      newquery = component.query memory
      store query, state, newquery, (err, result) ->
        return cb err if err?
        state = result
        query = newquery
        cb()
    
    unmount: ->
      scene.unmount()
      scene = null
    
    params: -> memory
  
  Relay