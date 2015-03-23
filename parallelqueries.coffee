# Spin up to max number of parallel, cancellable tasks referenced by key. New tasks cancel and replace older tasks with the same key.
module.exports = (max, idle) ->
  _running = {}
  _queued = {}
  start = (key, task) ->
    _running[key] = task ->
      delete _running[key]
      next()
      idle() if idle? and Object.keys(_running).length is 0
    next()
  next = ->
    return if Object.keys(_queued).length is 0
    return if Object.keys(_running).length >= max
    key = Object.keys(_queued)[0]
    task = _queued[key]
    delete _queued[key]
    start key, task
  result =
    cancel: (key) ->
      if _running[key]?
        _running[key]()
        delete _running[key]
      if _queued[key]?
        delete _queued[key]
    exec: (key, task) ->
      result.cancel key
      _queued[key] = task
      next()