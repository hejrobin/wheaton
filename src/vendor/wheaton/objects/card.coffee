Emitter                   = require '../event/emitter'
Properties                = require './properties'
{extend}                  = require '../utils'

class Card extends Emitter

  defaultProperties =
    guid: readonly: yes, validates: (property) -> typeof property is 'string'
    name: readonly: yes, validates: (property) -> typeof property is 'string'
    drawn: default: no, validates: (property) -> typeof property is 'boolean'
    played: default: no, validates: (property) -> typeof property is 'boolean'
    palmed: default: no, validates: (property) -> typeof property is 'boolean'
    discarded: default: no, validates: (property) -> typeof property is 'boolean'

  defaultOptions:
    onDraw: -> return
    onPlay: -> return
    onPalm: -> return
    onRevive: -> return
    onDiscard: -> return

  instanceOptions: {}

  constructor: (cardProperties = {}) ->
    instanceOptions = cardProperties.instanceOptions ? {}
    delete cardProperties.instanceOptions
    cardProperties = Properties.normalize cardProperties, defaultProperties
    Properties.define this, cardProperties
    @options(@defaultOptions).options instanceOptions
    return

  options: (newOptions = {}) ->
    @instanceOptions = extend @instanceOptions, newOptions
    this

  call: (callable, callableArguments...) ->
    if typeof callable is 'function'
      callable.apply this, callableArguments
    this

  draw: ->
    unless @drawn
      @drawn = yes
      @call @instanceOptions.onDraw
      @emit 'draw', this
    this

  play: ->
    if @drawn and not @played
      @call @instanceOptions.onPlay
      @emit 'play', this
      @played = true
    this

  palm: ->
    if @drawn and not @palmed
      @call @instanceOptions.onPalm
      @emit 'palm', this
      @palmed = yes
    this

  revive: ->
    if @drawn and @discarded
      @call @instanceOptions.onRevive
      @emit 'revive', this
      @discarded = no
    this

  discard: ->
    if @drawn and not @discarded
      @call @instanceOptions.onDiscard
      @emit 'discard', this
      @discarded = yes
    this


module.exports = Card
