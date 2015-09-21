path                      = require 'path'

class Wheaton

  @import: (wheatonPackage) ->
    console.warn 'Deprecation warning: Objects are exposed to Wheaton.'
    require path.join(__dirname, wheatonPackage)


module.exports.import = Wheaton.import
module.exports.Storage = require './data/storage'
module.exports.Deck = require './objects/deck'
module.exports.Card = require './objects/card'
