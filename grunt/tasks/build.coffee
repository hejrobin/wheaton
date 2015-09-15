module.exports = (grunt) ->

  grunt.registerTask 'build', 'Lints, compiles and builds wheaton package.', ->

    compileProduction = grunt.option 'production'

    if compileProduction is on
      grunt.task.run 'env:production'

    grunt.task.run 'coffeelint'
    grunt.task.run 'coffee'
