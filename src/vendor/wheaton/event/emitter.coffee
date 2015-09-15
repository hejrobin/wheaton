class Emitter

  defaultMaxListeners: 10

  maxListeners: null

  eventListeners: {}

  setMaxListeners: (@maxListeners) ->
    this

  getMaxListeners: ->
    if typeof @maxListeners is 'number' then @maxListeners else @defaultMaxListeners

  hasListeners: (eventType) ->
    @eventListeners.hasOwnProperty eventType

  listeners: (eventType) ->
    if @hasListeners eventType then @eventListeners[eventType] else []

  listenerCount: (eventType) ->
    @listeners(eventType).length

  hasListener: (eventType, eventCallback) ->
    if @hasListeners eventType
      return yes if @eventListeners[eventType].indexOf(eventCallback) > -1
    no

  addListener: (eventType, eventCallback) ->
    unless @hasListeners eventType
      @eventListeners[eventType] = []
    unless @listenerCount(eventType) >= do @getMaxListeners
      unless @hasListener eventType, eventCallback
        @eventListeners[eventType].push eventCallback
    this

  addOnceListener: (eventType, eventCallback) ->
    onceListener = =>
      @removeListener eventType, onceListener
      eventCallback.call arguments
    @addListener eventType, onceListener
    this

  removeListener: (eventType, eventCallback) ->
    if @hasListeners eventType
      listenerCallbackIndex = @listeners(eventType).indexOf eventCallback
      if listenerCallbackIndex >= 0
        @eventListeners[eventType].splice listenerCallbackIndex, 1
    this

  removeAllListeners: (eventTypes...) ->
    if eventTypes.length is 0
      @eventListeners = {}
      return this
    for eventType in eventTypes
      if @hasListeners eventType
        delete @eventListeners[eventType]
    this

  emit: (eventType, callbackArguments...) ->
    if @eventListeners.hasOwnProperty eventType
      for eventType, eventCallbacks of @eventListeners
        for eventCallback in eventCallbacks
          eventCallback.call callbackArguments

  on: -> @addListener.apply this, arguments

  once: -> @addOnceListener.apply this, arguments

  off: -> @removeListener.apply this, arguments


module.exports = Emitter
