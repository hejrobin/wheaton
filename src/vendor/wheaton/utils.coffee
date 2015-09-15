class Utils

  @extend: (targetObject, mutableObjects...) ->
    for sourceObject in mutableObjects
      for key of sourceObject
        if sourceObject.hasOwnProperty key
          targetObject[key] = sourceObject[key]
    targetObject

  @serialize: (sourceObject) ->
    JSON.stringify sourceObject

  @parameterize: (sourceObject, prefix = null) =>
    segments = []
    for key, data of sourceObject
      key = "#{prefix}[#{key}]" if prefix?
      if typeof data is 'object'
        segments.push @parameterize data, key
      else
        segments.push "#{encodeURIComponent key}=#{encodeURIComponent data}"
    segments.join '&'

  @mutable: (prototypable) ->

    get: (propertyName, propertyCallback, propertyDescription = {}) ->
      propertyDescription = Utils.extend
        get: propertyCallback
        configurable: yes
        enumerable: yes,
        propertyDescription

      Object.defineProperty prototypable,
        propertyName
        propertyDescription

    set: (propertyName, propertyCallback, propertyDescription = {}) ->
      propertyDescription = Utils.extend
        set: propertyCallback
        configurable: yes
        enumerable: yes,
        propertyDescription

      Object.defineProperty prototypable,
        propertyName
        propertyDescription


module.exports = Utils
