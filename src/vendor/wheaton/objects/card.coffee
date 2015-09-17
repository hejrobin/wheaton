Emitter                   = require '../event/emitter'
Properties                = require './properties'
{extend}                  = require '../utils'

class Card extends Emitter

  defaultProperties =
    guid:         readonly: yes,  validates: Properties.PropTypes.string
    name:         readonly: yes,  validates: Properties.PropTypes.string
    drawn:        default: no,    validates: Properties.PropTypes.bool
    played:       default: no,    validates: Properties.PropTypes.bool
    palmed:       default: no,    validates: Properties.PropTypes.bool
    discarded:    default: no,    validates: Properties.PropTypes.bool
    deckLimit:    default: 1,     validates: Properties.PropTypes.number
    quantity:     default: 1,     validates: Properties.PropTypes.number
    description:  validates: Properties.PropTypes.string

  instanceProperties: {}

  defaultOptions:
    onDraw: -> return
    onPlay: -> return
    onPalm: -> return
    onRevive: -> return
    onDiscard: -> return

  instanceOptions: {}

  constructor: (cardProperties = {}) ->
    instanceOptions = {}
    if cardProperties.hasOwnProperty 'instanceOptions'
      instanceOptions = cardProperties.instanceOptions
      delete cardProperties.instanceOptions
    cardProperties = Properties.normalize defaultProperties, cardProperties
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
