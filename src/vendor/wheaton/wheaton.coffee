class Wheaton

  @import: (wheatonPackage) ->
    require "./#{wheatonPackage.toLowerCase()}"


module.exports = Wheaton
