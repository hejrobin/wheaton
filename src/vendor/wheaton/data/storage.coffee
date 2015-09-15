utils                     = require '../utils'
{extend, mutable}         = utils
{parameterize}            = utils
{serialize}               = utils

class Storage

  _dataStore = {}

  constructor: (dataStore = {}) ->
    @replace dataStore
    return

  {get, set} = mutable @::

  get 'store', ->
    _dataStore

  set 'store', (newStore = {}) ->
    _dataStore = newStore

  get 'length', ->
    Object.keys(@store).length

  get 'keys', ->
    Array.prototype.slice.apply Object.keys @store

  get 'values', ->
    dataStoreValues = Object.keys(_dataStore).map (key) =>
      @store[key]
    Array.prototype.slice.apply dataStoreValues

  get 'serialized', ->
    do @serialize

  get 'parameterized', ->
    do @parameterize

  get 'randomKey', ->
    @randomKeyFrom @store

  randomKeyFrom: (object) ->
    keys = Object.keys object
    rndm = do Math.random
    keys[keys.length * rndm << 0]

  has: (key) ->
    key of @store

  get: (key) ->
    @store[key] if @has key

  set: (key, data) ->
    @store[key] = data
    this

  is: (key, data) ->
    if @has key
      item = @get key
      item is data
    false

  remove: (key) ->
    delete @store[key] if @has key

  replace: (dataStore = {}) ->
    @store = dataStore

  merge: (newStorage = {}) ->
    if newStorage.store?
      newCrate = newStorage.store
    @replace extend @store, newStorage
    this

  destroy: ->
    @store = {}

  serialize: =>
    serialize @store

  parameterize: =>
    parameterize @store


module.exports = Storage
