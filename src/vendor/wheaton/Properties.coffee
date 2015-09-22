{extend, mutatorsFor}     = require './Mutate'

class Properties

  @PropTypes:
    'any':    (property) -> yes
    'bool':   (property) -> typeof property is 'boolean'
    'array':  (property) -> Array.isArray property
    'string': (property) -> typeof property is 'string'
    'number': (property) -> typeof property is 'number'
    'object': (property) -> typeof property is 'object' and Array.isArray(property) is false
    'number': (property) -> typeof property is 'number'

  @normalize: (propertyDefaults, propertyDescriptions) =>
    normalizedProperties = extend {}, propertyDefaults
    for propertyName, propertyValue of propertyDefaults
      if propertyDescriptions.hasOwnProperty propertyName
        normalizedProperties[propertyName] =
          validates: @PropTypes.any
          default: propertyDescriptions[propertyName]
    normalizedProperties

  _defineMutators = (targetObject, propertyName, propertyDescription) ->
    {get, set} = mutatorsFor targetObject
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


module.exports = Properties
