module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee: 
      dist: 
        expand: true
        flatten: false
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib'
        ext: '.js'
    watch: 
      files: ['src/*.coffee']
      tasks: ['coffee'],
      options: 
        spawn: false

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.registerTask 'default', ['coffee']

