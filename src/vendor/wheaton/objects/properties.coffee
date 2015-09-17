{mutable, extend}         = require '../utils'

class Properties

  @normalize: (propertyDefaults, propertyDescriptions) =>
    normalizedProperties = extend {}, propertyDefaults
    for propertyName, propertyValue of propertyDefaults
      if propertyDescriptions.hasOwnProperty propertyName
        normalizedProperties[propertyName] =
          validates: @PropTypes.any
          default: propertyDescriptions[propertyName]
    normalizedProperties

  _defineMutators = (targetObject, propertyName, propertyDescription) ->
    {get, set} = mutable targetObject
    readonly = propertyDescription.hasOwnProperty 'readonly'

    get propertyName, ->
      if targetObject.instanceProperties? and targetObject.instanceProperties.hasOwnProperty propertyName
        propertyValue = targetObject.instanceProperties[propertyName].value
        propertyDefault = targetObject.instanceProperties[propertyName].default
        return propertyValue ? propertyDefault

    set propertyName, (propertyValue) ->
      return if readonly
      if propertyDescription.validates? and typeof propertyDescription.validates is 'function'
        targetObject.instanceProperties[propertyName].value = propertyValue
      return

  @define: (targetObject, propertyDescriptions) ->
    targetObject.instanceProperties = propertyDescriptions
    for own propertyName, propertyDescription of targetObject.instanceProperties
      _defineMutators targetObject, propertyName, propertyDescription
    return

  @PropTypes:
    'any':    (property) -> yes
    'bool':   (property) -> typeof property is 'boolean'
    'array':  (property) -> typeof property is 'array'
    'string': (property) -> typeof property is 'string'
    'number': (property) -> typeof property is 'number'
    'object': (property) -> typeof property is 'object'
    'number': (property) -> typeof property is 'number'


module.exports = Properties
