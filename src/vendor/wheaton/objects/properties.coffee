{mutable}                 = require '../utils'

class Properties

  _properties = {}

  @normalize: (propertyDefaults, propertyDescriptions) ->
    for propertyName, propertyValue of propertyDefaults
      if propertyDescriptions.hasOwnProperty propertyName
        propertyDescriptions[propertyName].default = propertyValue
    propertyDescriptions

  @define: (targetObject, propertyDescriptions) ->
    {get, set} = mutable targetObject
    for propertyName, propertyDescription of propertyDescriptions
      get propertyName, ->
        if _properties[propertyName]?
          return _properties[propertyName]
        return propertyDescription.default ? null
      unless propertyDescription.readonly?
        canDefineSetter = yes
        if propertyDescription.validates? and typeof propertyDescription.validates is 'function'
          canDefineSetter = propertyDescription.validates.apply targetObject, [propertyDescription.default ? null]
        if canDefineSetter
          set propertyName, (propertyValue) ->
            _properties[propertyName] = propertyValue
        return


module.exports = Properties
