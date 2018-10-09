module.exports = (grunt) ->
  'use strict'

  require('time-grunt') grunt

  config =
    timestamp: new Date().getTime()
  loadConfig = (path) ->
    glob = require 'glob'
    object = {}
    glob.sync '*',
      cwd: path
    .forEach (option) ->
      key = option.replace /\.js$/, ''
      object[key] = require path + option
      return
    object
  runTargetedTask = (tasks, taskTarget) ->
    if taskTarget
      i = 0
      while i < tasks.length
        if config[tasks[i]][taskTarget]
          tasks[i] += ':' + taskTarget
        i++
    grunt.task.run tasks
    return

  grunt.util._.extend config, loadConfig('./grunt/task/')
  grunt.initConfig config

  require('load-grunt-tasks') grunt

  grunt.registerTask 'css-dist', (taskTarget) ->
    runTargetedTask [
      'sass'
      'postcss'
      'cssmin'
    ], taskTarget
    return
  grunt.registerTask 'js-dist', (taskTarget) ->
    runTargetedTask [
      'coffee'
      'uglify'
    ], taskTarget
    return
  grunt.registerTask 'json-dist', (taskTarget) ->
    runTargetedTask [
      'minjson'
    ], taskTarget
  grunt.registerTask 'html-dist', (taskTarget) ->
    runTargetedTask [
      'htmlmin'
    ], taskTarget
    return
  grunt.registerTask 'build', ->
    runTargetedTask [
      'checkDependencies'
      'clean'
      'sass'
      'postcss'
      'cssmin'
      'coffee'
      'uglify'
      'htmlmin'
    ], 'main'
    return
  grunt.registerTask 'dev', ->
    devTasks = [
      'checkDependencies:dev'
      'connect:dev'
    ]
    config.watch['main'].tasks.forEach (task) ->
      if task.indexOf('notify:') is -1
        devTasks.push task
    devTasks.push 'watch'
    grunt.task.run devTasks
    return
  grunt.registerTask 'default', [
    'dev'
  ]
  return