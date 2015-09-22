EventEmitter              = require './EventEmitter'
Properties                = require './Properties'
{extend}                  = require './Mutate'

class Card extends EventEmitter

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

  defaultOptions: {}

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

  add: ->
    unless @discarded
      @emit 'add', this
      @quantity++
      if @quantity > @deckLimit
        @quantity = @deckLimit
      else
        @emit 'added', this
    this

  draw: ->
    unless @drawn
      @emit 'draw', this
      @drawn = yes
      @quantity--
      @quantity = 0 if @quantity < 0
      @emit 'drawn', this
    this

  play: ->
    if @drawn and not @played
      @emit 'play', this
      @played = true
      @emit 'played', this
    this

  palm: ->
    if @drawn and not @palmed
      @emit 'palm', this
      @palmed = yes
      @emit 'palmed', this
    this

  revive: ->
    if @drawn and @discarded
      @emit 'revive', this
      @discarded = no
      @emit 'revived', this
    this

  discard: ->
    if @drawn and not @discarded
      @emit 'discard', this
      @quantity = 0
      @discarded = yes
      @emit 'discarded', this
    this


module.exports = Card
