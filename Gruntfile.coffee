module.exports = (grunt) ->

  global.gruntConfiguration ?= {}

  require('matchdep')
    .filterDev('grunt-*')
    .forEach grunt.loadNpmTasks

  require('./grunt/task-options')
    .loadTasksOptions()

  grunt.task.loadTasks './grunt/tasks'
  grunt.initConfig global.gruntConfiguration
