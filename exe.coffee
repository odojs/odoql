builtinsources = [
  require './ops/boolean'
  require './ops/conditional'
  require './ops/maths'
  require './ops/transform'
]
builtin = {}
for opssource in builtinsources
  for _, optype of opssource
    for name, fn of optype
      builtin[name] = fn

exe = (def) ->
  providers = {}
  providers.literal = (exe, value) -> (cb) -> cb null, value
  providers[name] = fn for name, fn of builtin
  if def?
    providers[name] = fn for name, fn of def
  res =
    providers: providers
    isquery: (q) ->
      return no unless typeof(q) is 'object'
      q.__query?
    build: (q) ->
      return res.providers.literal res, q unless res.isquery q
      if !res.providers[q.__query]?
        throw new Error "#{q.__query} not found"
      return res.providers[q.__query] res, q
  res
exe.use = exe
module.exports = exe