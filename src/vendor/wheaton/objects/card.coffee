Emitter                   = require '../event/emitter'
utils                     = require '../utils'
{extend, mutable}         = utils
{serialize}               = utils

class Card extends Emitter

  {get, set} = mutable @::

  _isDrawn = no

  _isPlayed = no

  _isPalmed = no

  _isDiscarded = no

  get 'drawn', -> _isDrawn

  get 'played', -> _isPlayed

  get 'palmed', -> _isPalmed

  get 'discarded', -> _isDiscarded

  get 'serialized', ->
    serialize
      isDrawn: _isDrawn
      isPlayed: _isPlayed
      isPalmed: _isPalmed
      isDiscarded: _isDiscarded

  defaultOptions:
    onDraw: -> return
    onPlay: -> return
    onPalm: -> return
    onRevive: -> return
    onDiscard: -> return

  instanceOptions: {}

  cardName: null

  constructor: (@cardName, instanceOptions = {}) ->
    @options(@defaultOptions).options instanceOptions

  options: (newOptions = {}) ->
    @instanceOptions = extend @instanceOptions, newOptions
    this

  call: (callable, callableArguments...) ->
    if typeof callable is 'function'
      callable.apply this, callableArguments
    this

  draw: ->
    unless @drawn
      _isDrawn = yes
      @call @instanceOptions.onDraw
      @emit 'draw', this
    this

  play: ->
    if @drawn and not @played
      @call @instanceOptions.onPlay
      @emit 'play', this
      _isPlayed = yes
    this

  palm: ->
    if @drawn and not @palmed
      @call @instanceOptions.onPalm
      @emit 'palm', this
      _isPalmed = yes
    this

  revive: ->
    if @drawn and @discarded
      @call @instanceOptions.onRevive
      @emit 'revive', this
      _isDiscarded = no
    this

  discard: ->
    if @drawn and not @discarded
      @call @instanceOptions.onDiscard
      @emit 'discard', this
      _isDiscarded = yes
    this


module.exports = Card
