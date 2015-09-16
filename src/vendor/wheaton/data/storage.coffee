utils                     = require '../utils'
{extend, mutable}         = utils
{parameterize}            = utils
{serialize}               = utils

class Storage

  {get, set} = mutable @::

  _dataStore = {}

  constructor: (dataStore = {}) ->
    @replace dataStore
    return

  get 'data', ->
    _dataStore

  set 'data', (newStore = {}) ->
    _dataStore = newStore

  get 'size', ->
    Object.keys(@data).length

  get 'keys', ->
    Array.prototype.slice.apply Object.keys @data

  get 'shuffledKeys', ->
    shuffledKeys = @keys
    currentIndex = @size
    randomIndex = undefined
    tmp = undefined
    while 0 isnt currentIndex
      randomIndex = @randomKey
      currentIndex -= 1
      tmp = shuffledKeys[currentIndex]
      shuffledKeys[currentIndex] = shuffledKeys[randomIndex]
      shuffledKeys[randomIndex] = tmp
    shuffledKeys

  get 'values', ->
    dataStoreValues = Object.keys(_dataStore).map (key) =>
      @data[key]
    Array.prototype.slice.apply dataStoreValues

  get 'serialized', ->
    do @serialize

  get 'parameterized', ->
    do @parameterize

  get 'randomKey', ->
    keys = @keys
    rndm = do Math.random
    keys[keys.length * rndm << 0]

  get 'firstKey', ->
    @keys[0]

  get 'lastKey', ->
    @keys[@size - 1]

  get 'random', ->
    @data[@randomKey]

  get 'first', ->
    @data[@firstKey]

  get 'last', ->
    @data[@lastKey]

  has: (keys...) ->
    keys.map (key) =>
      @keys.indexOf key
    .indexOf(-1) is -1

  includes: (mixedValues...) ->
    mixedValues.map (mixedValue) =>
      @values.indexOf mixedValue
    .indexOf(-1) is -1

  get: (key) ->
    if @has key then @data[key] else null

  set: (key, data) ->
    @data[key] = data
    this

  is: (key, data) ->
    if @has key
      item = @get key
      return item is data
    false

  grab: (key) ->
    data = @get key
    @remove key
    data

  remove: (key) ->
    delete @data[key] if @has key
    this

  replace: (dataStore = {}) ->
    @data = dataStore
    this

  merge: (dataStore = {}) ->
    if dataStore instanceof Storage
      dataStore = dataStore.data
    @replace extend @data, dataStore
    this

  shuffle: ->
    keys = @shuffledKeys
    _store = {}
    for key in keys
      _store[key] = @data[key]
    @replace _store
    this

  destroy: ->
    @data = {}
    this

  serialize: =>
    serialize @data

  parameterize: =>
    parameterize @data


module.exports = Storage
