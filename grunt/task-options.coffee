grunt = require 'grunt'

OptionsLoader =

  loadTasksOptions: ->
    taskLoadPath = './grunt/tasks/options/'
    loadPathPattern = "#{ taskLoadPath }{,**/}*.{js,coffee}"
    tasksOptions = grunt.file.expand loadPathPattern
    gruntConfiguration = global.gruntConfiguration ? {}

    for taskOptions in tasksOptions
      taskName = taskOptions.replace /\.(js|coffee)$/, ''
      taskName = do taskName.split('/').pop
      taskModule = taskLoadPath + taskName
      grunt.verbose.writeln "Loading task options for #{ taskName }"
      gruntConfiguration[taskName] = require ".#{ taskModule }"

    global.gruntConfiguration = gruntConfiguration
    return


module.exports = OptionsLoader
