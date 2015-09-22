require 'es5-shim'
require 'es6-shim'

class Randomize

  @between: (min, max) ->
    rndm = do Math.random
    rndm * (max - min) + min

  _pickFromArray = (list) ->
    rndm = do Math.random
    list[list.length * rndm << 0]

  _pickFromObject = (list) ->
    list[_pickFromArray Object.keys(list)]

  @pick: (list) ->
    isArray = Array.isArray list
    if typeof list is 'object' and isArray is false
      return _pickFromObject list
    else if isArray is true
      return _pickFromArray list
    null

  _weightedFromArray = (list, weights...) ->
    index = 0
    weight = []
    weightSum = 0
    for key, val of list
      weight[key] = weights[key] ? .5
    totalWeight = weight.reduce (prev, current, index, list) ->
      prev + current
    rndm = @between 0, totalWeight
    while index < list.length
      weightSum += weight[index]
      weightSum = +weightSum.toFixed 2
      if rndm <= weightSum
        return list[index]
      index++
    return

  _weightedFromObject = (list, weights...) ->
    list[_weightedFromObject Object.keys(list), weights...]

  @weighted: (list, weights...) ->
    isArray = Array.isArray list
    if typeof list is 'object' and isArray is false
      return _weightedFromObject.apply(this, [list, weights...])
    else if isArray is true
      return _weightedFromArray.apply(this, [list, weights...])
    null


module.exports = Randomize
